class Crash{
  //What is the coordinate of the POI in lat, lon
  PVector coord;
  
  //Lat, lon values
  float lat;
  float lon;
  
  //fill color
  color fill;

  Crash(float lat, float lon){
    lat = lat;
    lon = lon;
    coord = new PVector();
    println(coord);
    fill = color(255, 0, 0);
  }
  
  void draw(){
      PVector coord = personLocations(landpeople).get(0);
      fill(color(255, 0, 0));
      noStroke();
      ellipse(coord.x-2, coord.y-2, 8, 8);
      println("Draw");
  }
  
  
}
