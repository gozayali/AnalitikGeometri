FloatList x, y; //<>//
float pointX=-1, pointY=-1;
int aralik=2;
boolean formulON = true;
boolean bilgi = true;
int loopCnt;

void setup() {
  size(800, 600);
  textSize(10);
  x=new FloatList();
  y=new FloatList();
/*  
  x.push(50);
  y.push(150);
  
  x.push(50);
  y.push(550);
  
  x.push(650);
  y.push(550);
  
  x.push(650);
  y.push(150);
*/ 
}

void draw() {
  background(0);
  loopCnt=0;
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
  if (pointSize>2 && pointX>=0) {

    for (int i=0; i<pointSize; i++) {
      if (i>0) {
        if (bilgi)
          println("KÖŞELER: "+i+"-"+(i-1));
        if (formulON)
          min_length_by_analytic_geometry(x.get(i), y.get(i), x.get(i-1), y.get(i-1), pointX, pointY);
        else
          min_length_by_point_sampling(x.get(i), y.get(i), x.get(i-1), y.get(i-1), pointX, pointY, aralik);
      } else {
        if (bilgi)
          println("KÖŞELER: "+i+"-"+(pointSize-1));
        if (formulON)
          min_length_by_analytic_geometry(x.get(0), y.get(0), x.get(pointSize-1), y.get(pointSize-1), pointX, pointY);
        else
          min_length_by_point_sampling(x.get(0), y.get(0), x.get(pointSize-1), y.get(pointSize-1), pointX, pointY, aralik);
      }
    }
    fill(255, 255, 0);
    ellipse(pointX, pointY, 5, 5);
    bilgi=false;
  }


  //  getArea(x, y);
  fill(250, 250, 0);
  text("KÖŞE EKLE:", 10, 10);
  text("TEST NOKTASI:", 10, 20);
  text("SON KÖŞEYİ SİL:", 10, 30);
  text("EKRANI TEMİZLE:", 10, 40);
  text("ALGORİTMA DEĞİŞTİR:", 10, 50);
  text("ARALIK DEĞİŞTİR:", 10, 60);
  text("LOOP COUNT:", 10, 70);

  fill(250);
  text("SOL MOUSE", 130, 10);
  text("SAĞ MOUSE", 130, 20);
  text("BACKSPACE", 130, 30);
  text("ENTER", 130, 40);
  text("SPACE", 130, 50);
  text("← "+aralik+" →", 130, 60);  
  text(loopCnt, 130, 70);
}

float min_length_by_point_sampling(float kose1_x, float kose1_y, float kose2_x, float kose2_y, float pt_x, float pt_y, int nokta_aralik) {
  float uzaklik = 10000000;
  float N_x=0;
  float N_y=0;

  float hipotenus = (float)(Math.sqrt(Math.pow((kose2_y - kose1_y), 2)+ Math.pow((kose2_x-kose1_x), 2)));
  noStroke();
  for (int j=0; j<hipotenus; j+=nokta_aralik) {    
    float P_y = kose1_y + j*(kose2_y - kose1_y)/hipotenus ;
    float P_x = kose1_x + j*(kose2_x-kose1_x)/hipotenus ;
    fill(255, 0, 255);
    ellipse(P_x, P_y, 2, 2);

    float tempUzaklik = (float)(Math.sqrt(Math.pow((pt_y - P_y), 2)+ Math.pow((pt_x-P_x), 2)));
    if (tempUzaklik<uzaklik) {
      uzaklik = tempUzaklik;
      N_x = P_x;
      N_y = P_y;
    }
    loopCnt++;
  }

  stroke(255, 0, 0);  
  line(N_x, N_y, pt_x, pt_y);
  fill(255);
  text(uzaklik, (pt_x+N_x)/2, (pt_y+N_y)/2);
  return uzaklik;
}

float min_length_by_analytic_geometry(float kose1_x, float kose1_y, float kose2_x, float kose2_y, float pt_x, float pt_y) {
  // denkleme ax+by+c=0 dersek
  float denklem_a = kose2_y - kose1_y;
  float denklem_b = kose1_x - kose2_x;
  float denklem_c = (kose1_y * kose2_x) - (kose1_x * kose2_y);

  // normalin denklemi ay-bx+d=0 olacak (eğimleri çarpımı -1) 
  float denklem_d = denklem_b*pt_x- denklem_a*pt_y;  

  // iki doğrunun kesişim noktası
  float N_y = -1*(denklem_b*denklem_c + denklem_a*denklem_d)/((float)Math.pow(denklem_a, 2)+(float)Math.pow(denklem_b, 2));
  float N_x = (denklem_b*denklem_d - denklem_a*denklem_c)/((float)Math.pow(denklem_a, 2)+(float)Math.pow(denklem_b, 2));

  // noktalar arası uzaklık
  float uzaklik;
  // Normalin çıktığı nokta doğru parçası içinde ise al, değilse en yakın köşeyi al
  if (bilgi) {
    println("N_x: "+N_x+"\tN_y: "+N_y);
    println("K1_x: "+kose1_x+"\tK1_y: "+kose1_y);
    println("K2_x: "+kose2_x+"\tK2_y: "+kose2_y);
  }
  if ( (kose1_y<=N_y && kose2_y>=N_y  ||  kose1_y>=N_y && kose2_y<=N_y) && (kose1_x<=N_x && kose2_x>=N_x  ||  kose1_x>=N_x && kose2_x<=N_x) ) {
    uzaklik = (float)Math.sqrt(Math.pow((pt_x-N_x), 2)+Math.pow((pt_y-N_y), 2));
    if (bilgi)
      println("ÜZERİNDEKİ : "+uzaklik);
  } else { 
    float kose1_uzaklik = (float)Math.sqrt(Math.pow((pt_x-kose1_x), 2)+Math.pow((pt_y-kose1_y), 2));
    float kose2_uzaklik = (float)Math.sqrt(Math.pow((pt_x-kose2_x), 2)+Math.pow((pt_y-kose2_y), 2));
    if (kose1_uzaklik<kose2_uzaklik) {
      N_x = kose1_x;
      N_y = kose1_y;
      uzaklik = kose1_uzaklik;
      if (bilgi)
        println("KÖŞE_1 : "+uzaklik);
    } else {
      N_x = kose2_x;
      N_y = kose2_y;
      uzaklik = kose2_uzaklik;
      if (bilgi)
        println("KÖŞE_2 : "+uzaklik);
    }
  }

  stroke(255, 0, 0);  
  line(N_x, N_y, pt_x, pt_y);
  fill(255);
  text(uzaklik, (pt_x+N_x)/2, (pt_y+N_y)/2);
  loopCnt++;
  return uzaklik;
}

boolean icerde(FloatList polyX, FloatList polyY, float ptX, float ptY) {
  int onceki=polyX.size()-1 ;
  int sagda=0;
  for (int i=0; i<polyX.size(); i++) {
    if ( polyY.get(i)<ptY && polyY.get(onceki)>=ptY ||  polyY.get(onceki)<ptY && polyY.get(i)>=ptY) // Doğru parçasının min-max Y değerleri arasındaysa      
      if ((ptY-polyY.get(i))/(polyY.get(onceki)-polyY.get(i))*(polyX.get(onceki)-polyX.get(i)) < (ptX-polyX.get(i))) // iki noktası bilinen doğru denkleminin sağında kalıyorsa       
        sagda++;          
    onceki=i;
  }
  // Aynı Y değeri hizasında kapalı şekil için çift sayıda doğru parçası olmak zorunda.
  // Sağda verisi tek sayıdaysa herhangi ikisinin arasında (şeklin içinde) demektir
  return sagda%2==1;
}

double getArea(FloatList polyX, FloatList polyY) {
  int onceki=polyX.size()-1 ;
  double area=0;
  double x=0;
  double y=0;
  for (int i=0; i<polyX.size(); i++) {
    x+=( polyX.get(onceki)+ polyX.get(i))*(polyX.get(onceki)*polyY.get(i)-polyX.get(i)*polyY.get(onceki));
    y+=( polyY.get(onceki)+ polyY.get(i))*(polyX.get(onceki)*polyY.get(i)-polyX.get(i)*polyY.get(onceki));
    area+= polyX.get(onceki)*polyY.get(i)-polyX.get(i)*polyY.get(onceki);
    onceki=i;
  }
  area=area/2;
  x=x/(6*area);
  y=y/(6*area);
  fill(255, 255, 0);
  // agırlık merkezi
  ellipse((float)x, (float)y, 10, 10);
  area=Math.abs(area);
  text(area+" px²", (float)(x-textWidth(area+" px²")/2), (float)(y-10));
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
  bilgi=true;
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
  if (keyCode==LEFT) {
    if (aralik>1) {
      aralik--;
    }
  }
  if (keyCode==RIGHT) {
    aralik++;
  }
  if (key == ' ') {
    formulON=!formulON;
  }
}