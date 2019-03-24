import java.util.*;
import processing.svg.*;

// Pointy tiles
// References a lot from https://www.redblobgames.com/grids/hexagons/

HashMap<String,int[]> directions=new HashMap<String, int[]>();
HashMap<String, HexNode> grid;
int[][] cubeDirections={{1,-1,0},{0,-1,1},{-1,0,1},{-1,1,0},{0,1,-1},{1,0,-1}};
PVector centerOfMaze;
float size;

void setup(){
   size(1000,1000);
     // purple-ish
    background(170, 170, 221);
    // dark-dark-blue  
    stroke(6, 6, 28);
    frameRate(10);
    int radius=45;
    float margin=50;
    
    int diameterAmount=radius*2+1;
    size = min((width-margin)/diameterAmount, (height-margin)/diameterAmount);
    size=size/sqrt(3);
    centerOfMaze=new PVector(height/2,width/2);
    
    grid=makeGrid(radius);
    carvePassagesFrom(grid.get("(0,0,0)"));
       
    beginRecord(SVG, "results.svg");
    for(HexNode node : grid.values()){
        drawHex(node);
    }
    endRecord();
}


class HexNode{
    int x,y,z;
    ArrayList<Integer> passageIndices;
    String nextOnPathDirection;
    boolean visited;
    
    HexNode(int x, int y, int z){
      this.x=x;
      this.y=y;
      this.z=z;
      this.passageIndices=new ArrayList<Integer>();
      this.visited=false;
    }
    
    String toString(){
        return String.format("(%d,%d,%d)",this.x,this.y,this.z);
    }
}

HashMap<String,HexNode> makeGrid(int radius){
    HashMap<String,HexNode> grid = new HashMap<String,HexNode>();
    for(int i = -radius; i < radius+1; i++){
        for(int j = -radius; j < radius+1; j++){
            for(int k = -radius; k < radius+1; k++){
              if(i+j+k==0){
                grid.put(String.format("(%d,%d,%d)",i,j,k), new HexNode(i,j,k));
              }
            }
        }
    }
    
    return grid;
    
}
boolean carvePassagesFrom(HexNode startNode){
    Integer[] neighbours = {0,1,2,3,4,5};
    List<Integer> is=Arrays.asList(neighbours);
    Collections.shuffle(is);
    boolean pathToTheEnd=false;
    startNode.visited=true;

    for(Integer i:is){
        HexNode neighbour=getNeighbour(startNode,i);
        if(neighbour != null&&!neighbour.visited){
            startNode.passageIndices.add(i);
            neighbour.passageIndices.add(mirrorIndex(i));
            neighbour.visited=true;
            carvePassagesFrom(neighbour);
            /*
            if(carvePassagesFrom(neighbour,endNode)){
                pathToTheEnd=true;
                startNode.setPath(i);
            }
            */
        }
    }
    // return pathToTheEnd||(startNode.equals(endNode));
    return true;
}

void drawHex(HexNode node){
    PVector center=hexCenter(node);
    for(int i=0; i<6;i++){
        if(!node.passageIndices.contains(i)){
            PVector from=hexCorner(center,i); 
            PVector to=hexCorner(center,i+1);
            line(from.x, from.y,to.x,to.y);
        }
    }
}

PVector hexCorner(PVector center, int i){
    float angle = 60 * i - 30;
    float angle_rad=PI/180*angle;
    return new PVector(center.x+size*cos(angle_rad),center.y+size*sin(angle_rad));
}

PVector hexCenter(HexNode node){
        float x=centerOfMaze.x+((node.x-node.y)*sqrt(3)*size/2);
        float y=centerOfMaze.y-((node.x+node.y)*3*size/2);
        return new PVector(x,y);
} 

HexNode getNeighbour(HexNode node, int i){
   int[] direction=cubeDirections[i];
   int x=node.x+direction[0];
   int y=node.y+direction[1];
   int z=node.z+direction[2];
   return grid.get(String.format("(%d,%d,%d)",x,y,z));
}

int mirrorIndex(int i){
    return (i+3)%6;
}
