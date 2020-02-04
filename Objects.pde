public class Cluster {
  // represented by a dot of randomly assigned colour
  float x, y;
  color Color;
  Cluster() {
  }
  Cluster(float x_, float y_) {
    x=x_;
    y=y_;
  }
  void randomInitialize() {
    x=random(width);
    y=random(height);
    Color=color(random(255), random(255), random(255));
  }
  void initialize() {
    if (pointsChosen) {
      int chosenPoint=int(random(noPoint));
      x=point[chosenPoint].x+1;
      y=point[chosenPoint].y+1;
      println("cluster chosen", x, y);
      Color=color(random(255), random(255), random(255));
    }
  }
  void drawCluster() {
    strokeWeight(10);
    stroke(Color);
    point(x, y);
  }
}

public class Point {
  float x, y;
  boolean chosen;
  color Color;
  int c;
  float lx, angle;
  Point() {
  }
  Point(float x_, float y_) {
    x=x_;
    y=y_;
    c = 0;
    chosen=false;
  }
  void randomInitialize(String type) {
    if (type == "RECT") {
      x=random(width);
      y=random(height);
    } else if (type == "CIRCLE") {
      lx = random(-width, width)/2;
      angle = random(TWO_PI);
      x = (lx*cos(angle))+width/2;
      y = (lx*sin(angle))+height/2;
    }
    Color=color(255);
  }
  void initialize() {
    int rand=floor(random(2));
    if (rand==0) {
      x=width/2+random(width/2);
      y=random(height/2);
    } else {
      x=random(width/2);
      y=height/2+random(height/2);
    }
    Color=color(255);
  }
  void choose() {
    chosen=true;
  }
  void drawPoint() {
    stroke(Color);
    strokeWeight(ptSize);
    if (ptType == "POINT") {
      point(x, y);
    } else if (ptType == "SQUARE") {
      rect(x, y, ptSize, ptSize);
    }
  }
}
void mousePressed() {
  // only used to manually input/change points
  int chosenIndex=checkChoose();
  if (chosenIndex!=-1) {
    point[chosenIndex].x=mouseX;
    point[chosenIndex].y=mouseY;
    println("chosen", point[chosenIndex].x, point[chosenIndex].y);
    point[chosenIndex].Color=color(255);
    point[chosenIndex].drawPoint();
    point[chosenIndex].chosen=false;
  }
}
int checkChoose() {
  for (int i=0; i<noPoint; i++) {
    if (point[i].chosen==true) {
      return i;
    }
  }
  return (-1);
}
