/*  PATHFINDER AND NETWORK ALGORITHMS
 *  Ira Winder, ira@mit.edu
 *  Nina Lutz, nlutz@mit.edu
 *  Coded w/ Processing 3 (Java)
 *
 *  The Main Tab "Tutoiral_3A_Agents" shows an example implementation of 
 *  algorithms useful for finding shortest pathes snapped to a gridded or OSM-based 
 *  network. Explore the various tabs to see how they work.
 *
 *  CLASSES CONTAINED:
 *
 *    Pathfinder() - Method to calculate shortest path between to nodes in a graph/network
 *    Graph() - Network of nodes and wighted edges
 *    Node() - Fundamental building block of Graph()
 *    ObstacleCourse() - Contains multiple Obstacles; Allows editing, saving, and loading of configuration
 *    Obstacle() - 2D polygon that can detect overlap events
 *    MercatorMap() - translate lat-lon to screen coordinates
 *    
 *    Standard GIS shapes:
 *    POI() - i.e. points, representing points of interest, etc
 *    Way() - i.e. lines, representing streets, paths, etc
 *    Polygons() - representing buildings, parcels, etc
 *
 *  FUNDAMENTAL OUTPUT: 
 *
 *    ArrayList<PVector> shortestPath = Pathfinder.findPath(PVector A, PVector B, boolean enable)
 *
 *  CLASS DEPENDENCY TREE: 
 *
 *
 *     POI() / Way()  ->  Node()  ->      Graph()        ->      Pathfinder()  ->  OUTPUT: ArrayList<PVector> shortestPath
 *
 *                                            ^                                        |
 *                                            |                                        v
 *
 *     Polygon()  ->  Obstacle()  ->  ObstacleCourse()                             Agent()                                   
 *
 */

PGraphics b;

// Make a blank map 
MercatorMap map;
//PImage background;

// Declare GIS-style Objects
ArrayList<POI> pois;
//ArrayList<BikeShops> bikeshops;
ArrayList<POI> shops;
ArrayList<POI> waterpoint;
ArrayList<Way> ways; 
ArrayList<Way> water;
ArrayList<Polygon> polygons;
ArrayList<Polygon> waterpolygons;
ArrayList<Polygon> buildingspolygon;
PVector flat; 
ArrayList<PVector> personLocations;
ArrayList<PVector> shopcoords;
ArrayList<PVector> waterpointcoords;

void setup() {
  
  size(1000, 650);
 // fullScreen ();
  
  b = createGraphics(width, height);
  
  /* Intiailize your data structures early in setup */
  map = new MercatorMap(width, height, 52.3722, 52.3649, 4.8694, 4.8893, 0);
  polygons = new ArrayList<Polygon>();
  waterpolygons = new ArrayList<Polygon>();
  buildingspolygon = new ArrayList<Polygon>();
  ways = new ArrayList<Way>();
  water = new ArrayList<Way>();
  //bikeshops = new ArrayList<BikeShops>(); 
  pois = new ArrayList<POI>();
  shops = new ArrayList<POI>();
  waterpoint = new ArrayList<POI>();
  shopcoords = new ArrayList<PVector>();
  waterpointcoords = new ArrayList<PVector>();
  
  /* Load in and parse your data in setup -- don't want to do this every frame! */
  loadData();
  parseData();
  loadwaterpointdata();
  /* Step 1: Initialize Network Using ONLY ONE of these methods */
  //randomNetwork(0.5); // a number between 0.0 and 1.0 specifies how 'porous' the network is
  waysNetwork(water);
  landwaysNetwork(ways);
  //randomNetworkMinusBuildings(0.1, polygons); // a number between 0.0 and 1.0 specifies how 'porous' the network is
  
  /* Step 2: Initialize Paths Using ONLY ONE of these methods */
  //randomPaths();
  poiPaths();
  landpoiPaths();
  
  /* Step 3: Initialize Paths Using ONLY ONE of these methods */
  initPopulation(10);
  landinitPopulation(50);
  //initPopulation(500);
  background(0);
  
 b.beginDraw();
  for(int i = 0; i<waterpolygons.size(); i++){
    waterpolygons.get(i).drawGraphic();
  }
  for(int i = 0; i<buildingspolygon.size(); i++){
    buildingspolygon.get(i).drawGraphic();
  }
  
  b.endDraw();
  
  
}

void draw() {
  background(0);
  image(b, 0, 0);
  /* background image from OSM */
 // image(background, 0, 0);
  drawGISObjects();
  
  /*  Displays the Graph in grayscale */

  
    /* Draw all polygons */ 
//  for(int i = 0; i<polygons.size(); i++){
  // polygons.get(i).draw();}
  
  /*  Displays the path last calculated in Pathfinder.
   *  The results are overridden everytime findPath() is run.
   *  FORMAT: display(color, alpha)
   */
  //boolean showVisited = true;
  //finder.display(255, 200, showVisited);
  
  /*  Displays the path properties.
   *  FORMAT: display(color, alpha)
   */
  //for (Path p: paths) {
  //  p.display(100, 50);
  //}
  //for (Path d: landpaths){
  //  d.display(100,50);
  //}
  
  //tint(255, 60); // overlaid as an image
//  image(network.img, 0, 0);
  
  
  /*  Update and Display the population of agents
   *  FORMAT: display(color, alpha)
   */
  boolean collisionDetection = true;
  for (Agent p: people) {
    p.update(personLocations(people), collisionDetection);
    p.display(#FFB400,255);
  }
   for (Agent p: landpeople) {
    p.update(personLocations(landpeople), collisionDetection);
    p.display(#FFffff,40);
  }
  
  //breakpoint colour
  
  if(flat != null){
  fill(#C63232);
  ellipse(flat.x, flat.y, 40, 40);
  }
  
  //this was the part that was drawing the green circle
//  if(closest != null){
//  fill(#72A746);
////  ellipse(closest.x, closest.y, 20, 20);
//  }
  
  if(closestshop != null){
  fill(#72A746);
  PVector closestshopScreen = map.getScreenLocation(closestshop);
  ellipse(closestshopScreen.x, closestshopScreen.y, 80, 80);
  }
  
  // colour closest canal
  
  if(closestcanal != null){
  fill(#C63232);
  PVector closestcanalScreen = map.getScreenLocation(closestcanal);
  ellipse(closestcanalScreen.x, closestcanalScreen.y, 20, 20);
  }
  
  //crash people 
  
  if (crashed == true) {
  for (Agent p: crashpeople){
    p.update(personLocations(crashpeople), collisionDetection);
    p.display(#C63232, 50);
    }
  for (Agent w: ambulanceboats){
    w.update(personLocations(ambulanceboats), collisionDetection);
    w.display(#0000FF, 250);
    }
  }
 
  
}


boolean crashed = false;
void keyPressed() {
    println(crashed);
    if (crashed == false) {
      //PVector flat = new PVector();
      flat = personLocations(landpeople).get(0);
      landpeople.remove(0);
      //people.remove(closest);
      //println("CLOSEST", closest);

     // println("Crash");
     //  
      closestToFlat();
      closestBikeshop();
      closestCanal();
      people.remove(closestIndex);
      println("CLOSEST", closest);
      bikeshoppoiPaths();
      ambulanceboatpoiPaths();
      crashinitPopulation(1);
      ambulanceboatinitPopulation(1);
      crashed = true;
    }
}
    
  PVector closest = null;
  int closestIndex = 0;
  
void closestToFlat(){
  float minDist = 1000000000;
  for(int i = 0; i<personLocations(people).size(); i++){
    float dist = dist(flat.x, flat.y, personLocations(people).get(i).x, personLocations(people).get(i).y);
    if(dist < minDist){
      minDist = dist;
      closest = personLocations(people).get(i);
      closestIndex = i;
      
      //Pink hollow indication circles
      //println(closest);
      //stroke(#ff1493);
      //strokeWeight(4);
      //noFill();
      //ellipse(closest.x, closest.y, 40, 40);
    }
  }
    println("Distance of closest roboat", minDist);
}

PVector closestshop = null;
PVector screenclosestshop = null;
void closestBikeshop(){
  float minDist = 1000000000;
  //println("number of things in shopcoords", shopcoords.size());
  //println("flat location: ", flat.x, flat.y);
  for(int j = 0; j<shopcoords.size(); j++){
    PVector screenLoc = map.getScreenLocation(shopcoords.get(j));
    float dist = dist(flat.x, flat.y, screenLoc.x, screenLoc.y);
    if(dist < minDist){
      minDist = dist;
      closestshop = shopcoords.get(j);
      screenclosestshop = map.getScreenLocation(shopcoords.get(j));
    }
  }
    println("Distance of closest bike shop", minDist);
}

PVector closestcanal = null;
PVector screenclosestcanal = null;
void closestCanal(){
  float minDist = 1000000000;
  //println("number of things in shopcoords", shopcoords.size());
  //println("flat location: ", flat.x, flat.y);
  for(int j = 0; j<waterpointcoords.size(); j++){
    PVector screenLoc = map.getScreenLocation(waterpointcoords.get(j));
    float dist = dist(flat.x, flat.y, screenLoc.x, screenLoc.y);
    if(dist < minDist){
      minDist = dist;
      closestcanal = waterpointcoords.get(j);
      screenclosestcanal = map.getScreenLocation(waterpointcoords.get(j));
    }
  }
  //println("Distance of closest canal", minDist);
}
