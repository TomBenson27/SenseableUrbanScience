class Polygon{
  //Shape, coordinates, and color variables
  PShape p;
  ArrayList<PVector>coordinates;
  color fill;
  color stroke;

  //Empty constructor
  Polygon(){
    coordinates = new ArrayList<PVector>();
  }
  
  //Constructor with coordinates
  Polygon(ArrayList<PVector> coords, int a){
    coordinates = coords;
    if(a == 1){
    fill = color(#163693,220);
    }
    else {
       stroke(0,0,0);
      fill = color(30,30,30);
 
    }
    makeShape();
  }
  
  //Making the shape to draw
  void makeShape(){
    p = createShape();
    p.beginShape();
    p.fill(fill);
    p.stroke(2);
    for(int i = 0; i<coordinates.size(); i++){
        PVector screenLocation = map.getScreenLocation(coordinates.get(i));
        p.vertex(screenLocation.x-55, screenLocation.y);
    }
    p.endShape();
  }

  //Drawing shape
  void draw(){
    shape(p, 50, 0);
  }
}
