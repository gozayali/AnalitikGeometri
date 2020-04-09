FloatList x, y;
float pointX=-1, pointY=-1;

void setup() {
  size(800, 600);
  textSize(10);
  x=new FloatList();
  y=new FloatList();
}

void draw() {
  background(0);

  // TÜM PİXELLERE BAK
  for (int i=0; i<width; i++)
    for (int j=0; j<height; j++)       
      if (icerde(x, y, i, j)) {
        noStroke();
        fill(0, 100, 0);
        rect(i, j, 1, 1);
      }

  // ŞEKLİ ÇİZ
  int pointSize=x.size();
  if (x.size()>0) {
    for (int i=0; i<pointSize; i++) {
      noStroke();
      fill(255);
      ellipse(x.get(i), y.get(i), 10, 10);
      text("P_"+i, x.get(i), y.get(i)-10);
      if (i>0) {
        stroke(0, 0, 255);
        line(x.get(i), y.get(i), x.get(i-1), y.get(i-1));
      }
    }
    if (pointSize>0) {
      stroke(0, 0, 255);
      line(x.get(pointSize-1), y.get(pointSize-1), x.get(0), y.get(0));
    }
  }


  // TEST NOKTASI ÇİZ
  if (pointX>-1&& pointY>-1) {
    fill(255, 0, 0);
    if (icerde(x, y, pointX, pointY))
      fill(0, 255, 0);
    noStroke();
    ellipse(pointX, pointY, 10, 10);
  }
  getArea(x,y);
  fill(250,250,0);
  text("KÖŞE EKLE:",10,10);
  text("TEST NOKTASI:",10,20);
  text("SON KÖŞEYİ SİL:",10,30);
  text("EKRANI TEMİZLE:",10,40);
  fill(250);
  text("SOL MOUSE",100,10);
  text("SAĞ MOUSE",100,20);
  text("BACKSPACE",100,30);
  text("ENTER",100,40);
  
}

boolean icerde(FloatList polyX, FloatList polyY, float ptX, float ptY) {
  int onceki=polyX.size()-1 ;  // ilk noktanın (0.nokta) önceki noktası listenin sonundaki noktadır
  int sagda=0;  // sağda kalan çizgi sayısı
  for (int i=0; i<polyX.size(); i++) {
    if ( polyY.get(i)<ptY && polyY.get(onceki)>=ptY ||  polyY.get(onceki)<ptY && polyY.get(i)>=ptY) // Nokta, doğru parçasının min-max Y değerleri arasındaysa      
      if ((ptY-polyY.get(i))/(polyY.get(onceki)-polyY.get(i))*(polyX.get(onceki)-polyX.get(i)) < (ptX-polyX.get(i))) // iki noktası bilinen doğru denkleminin sağında kalıyorsa       
        sagda++;          
    onceki=i;
  }
  // Nokta ile aynı Y değeri hizasında kapalı şekil için çift sayıda doğru parçası olmak zorunda.
  // Sağda verisi tek sayıdaysa herhangi ikisinin arasında (şeklin içinde) demektir
  return sagda%2==1;
}

double getArea(FloatList polyX, FloatList polyY){
  int onceki=polyX.size()-1 ;
  double area=0;
  double x=0;
  double y=0;
  for (int i=0; i<polyX.size(); i++){
    x+=( polyX.get(onceki)+ polyX.get(i))*(polyX.get(onceki)*polyY.get(i)-polyX.get(i)*polyY.get(onceki));
    y+=( polyY.get(onceki)+ polyY.get(i))*(polyX.get(onceki)*polyY.get(i)-polyX.get(i)*polyY.get(onceki));
    area+= polyX.get(onceki)*polyY.get(i)-polyX.get(i)*polyY.get(onceki);
    onceki=i;
  }
  area=area/2;
  x=x/(6*area);
  y=y/(6*area);
  fill(255,255,0);
  // agırlık merkezi
  ellipse((float)x,(float)y,10,10);
  area=Math.abs(area);
  text(area+" px²",(float)(x-textWidth(area+" px²")/2),(float)(y-10));
  return area;
}

void mousePressed() {
  if (mouseButton == LEFT) {
    x.push((float)mouseX);
    y.push((float)mouseY);
  } else if (mouseButton==RIGHT) {
    pointX=(float)mouseX;
    pointY=(float)mouseY;
  }
}

void keyPressed() {
  if (keyCode==ENTER) {
    x=new FloatList();
    y=new FloatList();
    pointX=-1;
    pointY=-1;
  }
  if (keyCode==BACKSPACE) {
    if (x.size()>0) {
      x.pop();
      y.pop();
    }
  }
}
