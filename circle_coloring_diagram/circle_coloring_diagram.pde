import processing.svg.*;

void setup(){
  size(595, 842);
  // Grey
  background(102);
  // White  
  stroke(255);
  noLoop();
  beginRecord(SVG, "results.svg");
}
void draw(){
  float r;
  float c_x;
  float c_y;
  int full_width=width;
  int full_height=height;
  int num_lines = 3;
  int lines_increment=1;
  int num_circles_width = 7;
  int num_circles_height = 11;
  int margin=25;
  

  r=min((full_height-2*margin)/((num_circles_height+0.5)*2),
        (full_width-2*margin)/((num_circles_width+0.5)*2));
  
  for(int z=0;z < num_circles_height; z++){
    c_y=margin+r+(r*2)*z;
    for(int i=0;i < num_circles_width; i++){
      c_x=margin+r+(r*2)*i;
      color_in_circle(r, c_x, c_y, num_lines);
      num_lines=num_lines+lines_increment;
    }
  }
  endRecord();
}
void color_in_circle(float r, float c_x, float c_y, int num_lines){
    PVector turtle=random_point_on_circle(r,c_x,c_y);
    PVector target;
    for(int j=0; j<num_lines; j++){
      target = random_point_on_circle(r,c_x,c_y);
      line(turtle.x, turtle.y, target.x, target.y);
      turtle=target.copy();
    }
}
PVector random_point_on_circle(float r, float c_x, float c_y){
    float angle = random(TWO_PI);
    float x=cos(angle)*r+c_x;
    float y=sin(angle)*r+c_y;
    return new PVector(x,y);
}
