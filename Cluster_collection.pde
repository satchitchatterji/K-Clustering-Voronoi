// Global variables

int noCluster=5; //number of colours/clusters to compute
int noPoint=7000; //number of points to be separated into clusters
int ptSize = 10; //size of each dot
// shape of each point = POINT, SQUARE
String ptType = "SQUARE";
// shape of working canvas = CIRCLE, RECT
String initType = "RECT";

Cluster cluster[]=new Cluster[noCluster];
Point point[]=new Point[noPoint];
float[] totalDistance=new float[noCluster];

void setup() {
  size(500, 500);
  //fullScreen();
  background(255);
  strokeWeight(5);
  randomInit();
}

// if autoRun() is commented out, the program
// runs incrementally with keystrokes
void draw() {
  autoRun();
}

boolean pointsChosen=false;
void randomInit() {
  // randomly initialises point and cluster positions on canvas
  counter=0;
  for (int i=0; i<noPoint; i++) {
    point[i]=new Point();
    point[i].randomInitialize(initType);
  }
  for (int i=0; i<noCluster; i++) {
    cluster[i]=new Cluster();
    cluster[i].randomInitialize();
  }
  drawDots();
}

// main implementation of k-means clustering in changeCenter()
// and visualized in changeColours()

void changeCenter() {
  // amends the cluster center position to the mean position of current points in cluster
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

void changeColors() {
  // changes point of colours of dots based on nearest cluster
  for (int i=0; i<noPoint; i++) {
    for (int j=0; j<noCluster; j++) {
      totalDistance[j]=((point[i].x-cluster[j].x)*(point[i].x-cluster[j].x)+(cluster[j].y-point[i].y)*(cluster[j].y-point[i].y));
    }
    int x=getMinimumIndex(totalDistance);
    point[i].Color=cluster[x].Color;
    point[i].c=x;
  }
}



void drawDots() {
  //draws points and cluster centers on canvas
  background(0);
  for (int p=0; p<noPoint; p++) {
    point[p].drawPoint();
  }
  for (int c=0; c<noCluster; c++) {
    cluster[c].drawCluster();
  }
}

int counter=0; //current frame, the algorithm is completed in two frames

void autoRun() {
  // checkStatic MUST come after counter++ else it'll break
  // when counter%2, change point alligiences
  // when !counter%2, update cluster positions
  if (paused) {
    return;
  }
  if (counter%2==0) {
    changeColors();
    counter++;
    println("Points Clustered");
    checkStatic();
  } else {
    changeCenter();
    counter++;
    println("Cluster Center changed");
  }
  drawDots();
  println("Frame#", counter);
}

int currentChosen = 0; //only used to add points manually to canvas
boolean paused = false;
void keyPressed() {
  // in autoRun mode, it resets automatically
  if (key == 's') {
    //save image to local folder
    saveFrame("voronoi#####.png");
    println("### Image saved! ###");
  } else if (key == 'p') {
    //makes sense only with autoRun
    paused = !paused;
    println("### PAUSE toggled! ###");
  } else if (key == 'r') {
    // reset
    randomInit();
  } else if (key == 'q') {
    // replace points to use-defined location
    addChosen(point[currentChosen%noPoint]);
    currentChosen++;
    println(currentChosen%noPoint);
    drawDots();
  } else {
    // increment algorithm, use any key apart from 's', 'r' and 'q' 
    if (counter%2==0) {
      changeColors();
      drawDots();
      counter++;
      println("Points Clustered");
      checkStatic();
    } else {
      changeCenter();
      drawDots();
      counter++;
      println("Cluster Center changed");
    }
    println("Frame#", counter);
  }
}

double pDist = 0;
void checkStatic() {
  // if sum of cluster distances to (0,0) is the same as the last frame
  // there is minimal movement; the algorithm stagnates
  // reset for aesthetic purposes 
  double totalDist = 0;
  for (int c=0; c<noCluster; c++) {
    totalDist+=dist(0, 0, cluster[c].x, cluster[c].y);
  }
  if (pDist == totalDist) {
    println("###RESET###");
    //delay(500);
    randomInit();
    pDist = 0;
  }
  pDist = totalDist;
  println("Cluster Dist to (0,0) = ", totalDist);
}

void addChosen(Point point) {
  // add custom points, use alongside pressing 'r'
  point.x = mouseX;
  point.y = mouseY;
}

int getMinimumIndex(float d[]) {
  //linear time, may be made more efficient with a binary search for the minimum
  int minIndex=0;
  float minimum=min(d);
  for (int c=0; c<noCluster; c++) {
    if (minimum==d[c]) {
      minIndex=c;
    }
  }
  return minIndex;
}
