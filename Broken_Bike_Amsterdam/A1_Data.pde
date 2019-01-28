JSONObject example;
JSONArray features;
JSONObject wholeArea;
//Look at https://processing.org/reference/JSONObject.html for more info

void loadData(){
  /* Load and resize background image */
  background = loadImage("exampledata.PNG");
  background.resize(width, height);
  
  /* Small example area */
  //example = loadJSONObject("data/example.json");
  //features = example.getJSONArray("features");
  
  /* Whole Area */
  wholeArea = loadJSONObject("exampledata.json");
  features = wholeArea.getJSONArray("features");
  
  println("There are : ", features.size(), " features."); 
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
    println(shop);
    
    //Make POIs if it's a point
    if(type.equals("Point")){
      //create new POI
      float lat = geometry.getJSONArray("coordinates").getFloat(1);
      float lon = geometry.getJSONArray("coordinates").getFloat(0);
      POI poi = new POI(lat, lon);
      if(shop!=null && shop.equals("bicycle")){
        shops.add(poi);
      }
      else pois.add(poi);
    }
    
    //Polygons if polygon
    if(type.equals("Polygon")){
      ArrayList<PVector> coords = new ArrayList<PVector>();
      //get the coordinates and iterate through them
      JSONArray coordinates = geometry.getJSONArray("coordinates").getJSONArray(0);
      for(int j = 0; j<coordinates.size(); j++){
        float lat = coordinates.getJSONArray(j).getFloat(1);
        float lon = coordinates.getJSONArray(j).getFloat(0);
        //Make a PVector and add it
        PVector coordinate = new PVector(lat, lon);
        coords.add(coordinate);
      }
      //Create the Polygon with the coordinate PVectors
      Polygon poly = new Polygon(coords);
      polygons.add(poly);
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
  
  /* Draw all polygons */ 
  for(int i = 0; i<polygons.size(); i++){
    polygons.get(i).draw();
  }
  
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
}
