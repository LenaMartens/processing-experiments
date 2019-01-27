import processing.svg.*;

void setup(){
  // A4
  size(595, 842);
  // purple-ish
  background(170, 170, 221);
  // dark-dark-blue  
  stroke(6, 6, 28);
  noLoop();
  beginRecord(SVG, "results.svg");
}
void draw(){

  int full_width=width;
  int full_height=height;
  int num_lines = 300;
  int margin=25;
  

  float r=min((full_height-2*margin)/2,
        (full_width-2*margin)/2);
  float c_x=full_width/2;
  float c_y=full_height/2;
  
  float rect_x=margin;
  float rect_y=margin;
  float r_width=full_width-2*margin;
  float r_height=full_height-2*margin;
  
  PVector turtle;
  PVector target;
  for(int i = 0; i < num_lines; i++){
    turtle=random_point_on_rectangle(rect_x, rect_y, r_width, r_height);
    target=random_point_on_circle(r, c_x, c_y);
    line(turtle.x, turtle.y, target.x, target.y);
  }
  
  }
  endRecord();
}

PVector random_point_on_rectangle(float x, float y, float r_width, float r_height){
    float x_or_y_choice = random(1);
    float side_choice = random(1);
    
    float new_x;
    float new_y;
    
    if(x_or_y_choice < 0.5){
      new_x=x+random(r_width-x);
      if(side_choice<0.5){
        new_y=y;
      }else{
        new_y=y+r_height;
      }
    }else{
      new_y=y+random(r_height-y);
      if(side_choice<0.5){
        new_x=x;
      }else{
        new_x=x+r_width;
      }
    }
    return new PVector(new_x,new_y);
}
PVector random_point_on_circle(float r, float c_x, float c_y){
    float angle = random(TWO_PI);
    float x=cos(angle)*r+c_x;
    float y=sin(angle)*r+c_y;
    return new PVector(x,y);
}
