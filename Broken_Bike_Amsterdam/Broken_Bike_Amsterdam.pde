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

// Make a blank map 
MercatorMap map;
//PImage background;

// Declare GIS-style Objects
ArrayList<POI> pois;
ArrayList<BikeShops> bikeshops;
ArrayList<POI> shops;
ArrayList<POI> waterpoint;
ArrayList<Way> ways; 
ArrayList<Way> water;
ArrayList<Polygon> polygons;
ArrayList<PVector> flats;

void setup() {
  size(1000, 650);
  
  /* Intiailize your data structures early in setup */
  map = new MercatorMap(width, height, 52.3722, 52.3649, 4.8694, 4.8893, 0);
  polygons = new ArrayList<Polygon>();
  ways = new ArrayList<Way>();
  water = new ArrayList<Way>();
  bikeshops = new ArrayList<BikeShops>(); 
  pois = new ArrayList<POI>();
  shops = new ArrayList<POI>();
  waterpoint = new ArrayList<POI>();
  
  flats = new ArrayList<PVector>();
  
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
  initPopulation(100);
  landinitPopulation(50);
  //initPopulation(500);
  
}

void draw() {
  background(0);
  
  /* background image from OSM */
 // image(background, 0, 0);
  drawGISObjects();
  
  /*  Displays the Graph in grayscale */
  tint(255, 75); // overlaid as an image
  image(network.img, 0, 0);
  
  /*  Displays the path last calculated in Pathfinder.
   *  The results are overridden everytime findPath() is run.
   *  FORMAT: display(color, alpha)
   */
  //boolean showVisited = true;
  //finder.display(255, 200, showVisited);
  
  /*  Displays the path properties.
   *  FORMAT: display(color, alpha)
   */
  for (Path p: paths) {
    p.display(100, 50);
  }
  for (Path d: landpaths){
    d.display(100,50);
  }
  
  /*  Update and Display the population of agents
   *  FORMAT: display(color, alpha)
   */
  boolean collisionDetection = true;
  for (Agent p: people) {
    p.update(personLocations(people), collisionDetection);
    p.display(#FF8C00, 250);
  }
   for (Agent p: landpeople) {
    p.update(personLocations(landpeople), collisionDetection);
    p.display(#FFFF00, 250);
  }
  
  for(PVector p : flats){
    fill(color(255,0,0));
    ellipse(p.x, p.y, 16, 16);
  }
}

void keyPressed() {
    //PVector flat = new PVector();
    flats.add(personLocations(landpeople).get(0));
    println(personLocations(landpeople).get(0));
    landpeople.remove(0);
    println("Crash");
    println("Crash Site");
    }
    
//void keyPressed() {
  
  //randomPaths();
  //poiPaths();
  //initPopulation(1000);
  
//}
