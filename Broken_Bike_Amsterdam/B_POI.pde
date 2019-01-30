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
    println(coord);
    if(a == 3){
    fill = color(255, 0, 225);
    }
    if (a == 4){
    fill = color(0,255,0);
    }
    else 
    fill(100,100,100);
  }
  
  void draw(){
    PVector screenLocation = map.getScreenLocation(coord);
    fill(fill);
    noStroke();
    rect(screenLocation.x-2, screenLocation.y-2, 16, 16);
  }
  
  
}
