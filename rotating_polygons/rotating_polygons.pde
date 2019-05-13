import processing.svg.*;

// Nice parameters
//int points=floor(random(3,10)); 
//int shapeReplications=floor(random(3,10));
int points=5; 
int shapeReplications=9;
int rotationReplications=23;

void setup(){
    // purple-ish
    background(170, 170, 221);
    // dark-dark-blue  
    stroke(6, 6, 28);
    size(595 ,842);
    textSize(32);
    text(points+","+shapeReplications, 10, 30); 
    beginRecord(SVG, "results.svg");
    translate(width/2, height/2);
    drawFunkyShape(points,shapeReplications,rotationReplications);
    endRecord();

}
/*
void draw(){
    clear();
     // purple-ish
    background(170, 170, 221);
    // dark-dark-blue  
    stroke(6, 6, 28);
    translate(width/2, height/2);
    drawFunkyShape(points,shapeReplications,rotationReplications);
    
    
    points=(points+1)%20;
    
}
*/
void drawFunkyShape(int points, int shapeReplications, int rotationReplications){
    float radius = min(width,height)/8;
    float rotationRadius=radius*1.5;
    
    PVector poc = pointOnCircle(0,rotationRadius);
    float x=poc.x;
    float y=poc.y;
    for(int j=1;j<rotationReplications+2;j++){
      for(int i=0; i<shapeReplications;i++){
          polygon(x,y,radius,points);
          rotate(TWO_PI/shapeReplications);
          poc = pointOnCircle(j*(TWO_PI/rotationReplications),rotationRadius);
          x=poc.x;
          y=poc.y;
      }
    }
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  float sx = x + radius;
  float sy = y;
  for (float a = 0; a < TWO_PI; a += angle) {
    float nx = x + cos(a) * radius;
    float ny = y + sin(a) * radius;
    line(sx,sy,nx,ny);
    sx=nx;
    sy=ny;
  }
  line(sx,sy,x + radius,y);
}

PVector pointOnCircle(float angle, float r){
  float x=cos(angle)*r;
  float y=sin(angle)*r;
  return new PVector(x,y);
}
