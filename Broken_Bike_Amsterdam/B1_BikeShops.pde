class BikeShops{
  //What is the coordinate of the POI in lat, lon
  PVector coord;
  
  //Lat, lon values
  float lat;
  float lon;
  
  //fill color
  color fill;

  BikeShops(float lat, float lon){
    lat = lat;
    lon = lon;
    coord = new PVector(lat, lon);
    println(coord);
    fill = color(255, 0, 225);
  }
  
  void draw(){
    PVector screenLocation = map.getScreenLocation(coord);
    fill(fill);
    noStroke();
    ellipse(screenLocation.x-2, screenLocation.y-2, 20, 20);
  }
  
}
