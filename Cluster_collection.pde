int noCluster=6;
int noPoint=10000;
int circleSize = 4;
// types = CIRCLE, RECT
String initType = "RECT";
float[] distance=new float[noCluster];

Cluster cluster[]=new Cluster[noCluster];
Point point[]=new Point[noPoint];

void setup() {
  size(500, 500);
  //fullScreen();
  background(255);
  strokeWeight(5);
  randomInit();
}

void draw() {
  autoRun();
  //print(frameRate);
}

boolean pointsChosen=false;
void randomInit() {
  counter=0;
  for (int i=0; i<noPoint; i++) {
    point[i]=new Point();
    point[i].randomInitialize(initType);
    //point[i].choose();
    //checkChosen();
  }
  // if (pointsChosen)
  for (int i=0; i<noCluster; i++) {
    cluster[i]=new Cluster();
    cluster[i].randomInitialize();
  }
  drawDots();
}

void changeColors() {
  for (int i=0; i<noPoint; i++) {
    for (int j=0; j<noCluster; j++) {
      distance[j]=((point[i].x-cluster[j].x)*(point[i].x-cluster[j].x)+(cluster[j].y-point[i].y)*(cluster[j].y-point[i].y));
    }
    int x=getMinimum(distance);
    point[i].Color=cluster[x].Color;
    point[i].c=x;
  }
}

int getMinimum(float d[]) {
  int minIndex=0;
  float minimum=min(d);
  for (int c=0; c<noCluster; c++) {
    if (minimum==d[c]) {
      minIndex=c;
    }
  }
  return minIndex;
}

void changeCenter() {

  for (int ca=0; ca<noCluster; ca++) {
    float totalx=0;
    float totaly=0;
    int total=0;
    for (int pa=0; pa<noPoint; pa++) {
      if (point[pa].c==ca) {
        totalx+=point[pa].x;
        totaly+=point[pa].y;
        total++;
      }
    }
    cluster[ca].x=totalx/total;
    cluster[ca].y=totaly/total;
  }
}

void drawDots() {
  background(0);
  for (int p=0; p<noPoint; p++) {
    point[p].drawPoint();
  }
  for (int c=0; c<noCluster; c++) {
    cluster[c].drawCluster();
  }
}
void showCluster() {
  for (int i=0; i<noCluster; i++) {
    println(i, cluster[i].x, cluster[i].y);
  }
}
void showCluster2() {
  for (int i=0; i<noCluster; i++) {
    println(i, (cluster[i].x-width/4), (cluster[i].y-height/4));
  }
}


int counter=0;
int currentChosen = 0;
void keyPressed() {
  if (key=='r') {
    // reset
    randomInit();
  }
  if (key=='s') {
    //shows cluster? I need better comments
    showCluster();
  }
  if (key=='d') {
    //I don't know how this is any different
    showCluster2();
    stroke(255, 0, 0);
    point(600/4, 600-600/4);
    point(600-600/4, 600/4);
  }
  if (key == 'q') {
    // replace points to use-defined location
    addChosen(point[currentChosen%noPoint]);
    currentChosen++;
    println(currentChosen%noPoint);
    drawDots();
  } else {
    if (counter%2==0) {
      changeColors();
      drawDots();
      counter++;
      println("key");
       checkStatic();
    } else {
      changeCenter();
      drawDots();
      counter++;
      println("Center");
    }
    println(counter);
  }
}
void autoRun(){
    if (counter%2==0) {
      changeColors();
      drawDots();
      counter++;
      println("key");
       checkStatic();
    } else {
      changeCenter();
      drawDots();
      counter++;
      println("Center");
    }
    println(counter);
}
//void checkChosen(){
//int total=0;
//  for(int i=0;i<noPoint;i++){
//if(point[i].chosen==true)
//total++;
//}
//}
double pDist = 0;
void checkStatic() {
  double totalDist = 0;
  for (int c=0; c<noCluster; c++) {
    totalDist+=dist(0, 0, cluster[c].x, cluster[c].y);
  }
  if (pDist == totalDist) {
    print("STOP");
    //delay(500);
    randomInit();
    pDist = 0;
  }
  pDist = totalDist;
  println("Dist = ",totalDist);
}

void addChosen(Point point) {
  point.x = mouseX;
  point.y = mouseY;
}
