JSONObject example;
JSONArray features;
JSONObject wholeArea;
Table waterpoints;
//Look at https://processing.org/reference/JSONObject.html for more info



void loadData(){
  /* Load and resize background image */
  //background = loadImage("exampledata.PNG");
 // background.resize(width, height);
  
  /* Small example area */
  //example = loadJSONObject("data/example.json");
  //features = example.getJSONArray("features");
  
  /* Whole Area */
  wholeArea = loadJSONObject("exampledata.json");
  features = wholeArea.getJSONArray("features");
  
  println("There are : ", features.size(), " features."); 
}

void loadwaterpointdata(){
  waterpoints = loadTable("10m_points.csv", "header");
  for (TableRow row: waterpoints.rows()){
    Float lat = row.getFloat("LONG");
    Float lon = row.getFloat("LAT");
    PVector waterpointcoord = new PVector(lat, lon);
    if(map.getScreenLocation(waterpointcoord).x > 0 && map.getScreenLocation(waterpointcoord).x 
    < width && map.getScreenLocation(waterpointcoord).y > 0 && map.getScreenLocation(waterpointcoord).y < height){
    //println(waterpointcoord);
    waterpointcoords.add(waterpointcoord);
    //println(waterpointcoords);
    int f = 1;
    POI poi = new POI(lat, lon, f);
    waterpoint.add(poi);
    }
  }
}

void parseData(){
  //First do the general object
  JSONObject feature = features.getJSONObject(0);

  //Sort 3 types into our respective classes to draw
  for(int i = 0; i< features.size(); i++){
    //Idenitfy 3 main things; the properties, geometry, and type 
    String type = features.getJSONObject(i).getJSONObject("geometry").getString("type");
    JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
    JSONObject properties =  features.getJSONObject(i).getJSONObject("properties");
    String waterway = features.getJSONObject(i).getJSONObject("properties").getJSONObject("tags").getString("waterway");
    String shop = features.getJSONObject(i).getJSONObject("properties").getJSONObject("tags").getString("shop");
    String waterpoly = features.getJSONObject(i).getJSONObject("properties").getJSONObject("tags").getString("natural");
    String building = features.getJSONObject(i).getJSONObject("properties").getJSONObject("tags").getString("building");    
    
    //Make POIs if it's a point
    if(type.equals("Point")){
      //create new POI
      ArrayList<PVector> coords = new ArrayList<PVector>();
      float lat = geometry.getJSONArray("coordinates").getFloat(1);
      float lon = geometry.getJSONArray("coordinates").getFloat(0);
      int e = 3;
      int a = 4;
      PVector coordinate = new PVector(lat, lon);
        coords.add(coordinate);

      if(shop!=null && shop.equals("bicycle")){
          POI poi = new POI(lat,lon,e);
          shops.add(poi);
          PVector shopcoord = new PVector(lat,lon);
            if(map.getScreenLocation(shopcoord).x > 0 && map.getScreenLocation(shopcoord).x 
            < width && map.getScreenLocation(shopcoord).y > 0 && map.getScreenLocation(shopcoord).y < height){
                shopcoords.add(shopcoord);
            }
          
      }
      else {
        POI poi = new POI(lat,lon,a); 
        pois.add(poi);
      }
    }
    
    //Polygons if polygon
    if(type.equals("Polygon")){
      int p = 1;
      int o = 2;
      int t = 5;
      ArrayList<PVector> coords = new ArrayList<PVector>();
      //get the coordinates and iterate through them
      JSONArray coordinates = geometry.getJSONArray("coordinates").getJSONArray(0);
      for(int j = 0; j<coordinates.size(); j++){
        float lat = coordinates.getJSONArray(j).getFloat(1);
        float lon = coordinates.getJSONArray(j).getFloat(0);
        //Make a PVector and add it
        PVector coordinate = new PVector(lat, lon);
        coords.add(coordinate);
      
      if(waterpoly != null && waterpoly.equals("water")){
        Polygon poly = new Polygon(coords, p);
        waterpolygons.add(poly);  
        
      }
      //if(shop!=null && shop.equals("bicycle") && building != null){
      //  Polygon poly = new Polygon(coords, t);
      //  bikeshoppolygons.add(poly);
      //  println(bikeshoppolygons);
      //}
      
      if(building != null){
       Polygon poly = new Polygon(coords, o);
       buildingspolygon.add(poly);
      }
      
      else {
      //Create the Polygon with the coordinate PVectors
      Polygon poly = new Polygon(coords, o);
      polygons.add(poly);
    }
      }
    }
    
    //Way if a LineString
    if(type.equals("LineString")){
      ArrayList<PVector> coords = new ArrayList<PVector>();
      //get the coordinates and iterate through them
      JSONArray coordinates = geometry.getJSONArray("coordinates");
      for(int j = 0; j<coordinates.size(); j++){
        float lat = coordinates.getJSONArray(j).getFloat(1);
        float lon = coordinates.getJSONArray(j).getFloat(0);
        //Make a PVector and add it
        PVector coordinate = new PVector(lat, lon);
        coords.add(coordinate);
      }
      //Create the Way with the coordinate PVectors
      Way way = new Way(coords, waterway);
      if(waterway!=null && waterway.equals("canal")){
        water.add(way);
      }
      else
            ways.add(way);
    }
    
  }
}

void drawGISObjects() {
  

 
   /* Draw all the ways (roads, sidewalks, etc) */
  for(int i = 0; i<ways.size(); i++){
    ways.get(i).draw();
  }
    for(int i = 0; i<water.size(); i++){
    water.get(i).draw();
  }

  /* Draw all POIs */
  //for(int i = 0; i<pois.size(); i++){
    //pois.get(i).draw();
  //}
  //Draw all shops
  for(int i = 0; i<shops.size(); i++){
    shops.get(i).draw();
  }
 //draw polygons
 //for(int i = 0; i<bikeshoppolygons.size(); i++){
 //   bikeshoppolygons.get(i).draw();
 // }
    //for(int i = 0; i<waterpoint.size(); i++){
    //waterpoint.get(i).draw();
  //}
}
