class Way{
  //Coordinates and color variables
  ArrayList<PVector>coordinates;
  color stroke;
  String waterway;
  
  //Empty constructor
  Way(){}
  
  //Constructor of coordinates
  Way(ArrayList<PVector> coords, String waterway){
    coordinates =  coords;
    
    if(waterway!=null && waterway.equals("canal")){
  stroke = color(0, 0, 255);
    }
    else stroke = color(60, 60, 60,160);
    
  }
  
  //Draw the road
  void draw(){
    strokeWeight(0.1);
    stroke(stroke);
    for(int i = 0; i<coordinates.size()-1; i++){
        //iterate through the coordinates and draw lines
        PVector screenStart = map.getScreenLocation(coordinates.get(i));
        PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
        line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
  }
  }
}
