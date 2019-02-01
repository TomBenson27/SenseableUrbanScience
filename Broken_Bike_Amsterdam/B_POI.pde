class POI{
  //What is the coordinate of the POI in lat, lon
  PVector coord;
  
  //Lat, lon values
  float lat;
  float lon;
  
  //fill color
  color fill;

  POI(float lat, float lon, int a){
    lat = lat;
    lon = lon;
    coord = new PVector(lat, lon);
  //  println(coord);
    if(a == 3){
    fill = color(#72A746,170);
    }
    if (a == 4){
    fill = color(#72A746);
    }
    else 
    fill(#72A746,180);
  }
  
  void draw(){
    PVector screenLocation = map.getScreenLocation(coord);
    fill(fill);
    noStroke();
    ellipse (screenLocation.x-2, screenLocation.y-2, 30, 30);
  }
  
  
}
