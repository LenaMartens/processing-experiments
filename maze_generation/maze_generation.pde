import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import processing.svg.*;


void setup(){
    size(1000,1000);
     // purple-ish
    background(170, 170, 221);
    // dark-dark-blue  
    stroke(6, 6, 28);
    frameRate(10);
    int cellAmount=70;
    
    beginRecord(SVG, "results.svg");

    float cellSize = min(width/cellAmount, height/cellAmount);
    ArrayList<ArrayList<Node>> grid = makeGrid(cellAmount,cellAmount);
    carvePassagesFrom(0,0,cellAmount-1,cellAmount-1,grid);
    
    renderMaze(grid, cellSize);
    endRecord();
}

class Node{
    int x,y;
    ArrayList<Node> neighbours;
    Node nextOnPath;
    
    Node(int x, int y){
        this.x=x;
        this.y=y;
        this.neighbours=new ArrayList<Node>();
    }
    
    void addNeighbour(Node neighbour){
        this.neighbours.add(neighbour);
    }
    void setPath(Node path){
        this.nextOnPath=path;
    }
    String toString(){
        return x+" , "+y;
    }
    
}
ArrayList<ArrayList<Node>> makeGrid(int gridWidth, int gridHeight){
    ArrayList<ArrayList<Node>> grid=new ArrayList<ArrayList<Node>>();
    for(int i=0; i<gridWidth; i++){
        ArrayList<Node> row=new ArrayList<Node>();
        for(int j=0; j<gridHeight; j++){
            row.add(new Node(i,j));
        }
        grid.add(row);
    }
    return grid;
}

boolean carvePassagesFrom(int startX,int startY, int endX, int endY, ArrayList<ArrayList<Node>> grid){
    int[][] directionsArray={{-1,0},{0,-1},{1,0},{0,1}};
    List<int[]> directions = Arrays.asList(directionsArray);
    Collections.shuffle(directions);
    boolean pathToTheEnd=false;
    
    for(int[] direction:directions){
        int nextX=startX+direction[0];
        int nextY=startY+direction[1];
        if(nextX > -1 && nextX < grid.size() 
        && nextY > -1 && nextY < grid.get(0).size() 
        && grid.get(nextX).get(nextY).neighbours.isEmpty()){
            grid.get(startX).get(startY).addNeighbour(new Node(nextX,nextY));
            grid.get(nextX).get(nextY).addNeighbour(new Node(startX,startY));
            if(carvePassagesFrom(nextX,nextY,endX, endY,grid)){
                pathToTheEnd=true;
                grid.get(startX).get(startY).setPath(grid.get(nextX).get(nextY));
            }
        }
    }
    return pathToTheEnd||(startX==endX&&startY==endY);
}

void renderMaze(ArrayList<ArrayList<Node>> grid, float cellSize){
    print("Rendering maze \n");
    for(int i = 0; i < grid.size(); i++){
        for(int j = 0; j < grid.get(0).size(); j++){
            boolean right=true;
            boolean down=true;
            Node currentNode = grid.get(i).get(j);
            
            ArrayList<Node> neighbours = currentNode.neighbours;
            for(Node neighbour : neighbours){
              if(neighbour.x-i==1&&neighbour.y==j){
                  right=false;
              }else if(neighbour.y-j==1&&neighbour.x==i){
                  down=false;
              }
            }
            if(currentNode.nextOnPath != null){
              Node pathNeighbour=currentNode.nextOnPath;
              //reddish
              stroke(200,0,0);
              float aX=i*cellSize+cellSize/2;
              float aY=j*cellSize+cellSize/2;
              float bX=(pathNeighbour.x)*cellSize+cellSize/2;
              float bY=(pathNeighbour.y)*cellSize+cellSize/2;
              line(aX,aY,bX,bY);
            }
            stroke(6, 6, 28);
            if(right){
                float aX=(i+1)*cellSize;
                float bX=aX;
                float aY=j*cellSize;
                float bY=(j+1)*cellSize;
                line(aX,aY,bX,bY);
            }
            if(down){
                float aX=i*cellSize;
                float bX=(i+1)*cellSize;
                float aY=(j+1)*cellSize;
                float bY=aY;
                line(aX,aY,bX,bY);
            }
        }
    }
}
