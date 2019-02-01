
// Objects to define our Network
//
ObstacleCourse course;
Graph network;
Graph landnetwork;
Pathfinder finder;

//  Object to define and capture a specific origin, destiantion, and path
ArrayList<Path> paths;
ArrayList<Path> landpaths;
ArrayList<Path> bikeshoppaths;
ArrayList<Path> ambulanceboatpaths;
PVector orig;
PVector dest;


//  Objects to define agents that navigate our environment
ArrayList<Agent> people;
ArrayList<Agent> landpeople;
ArrayList<Agent> crashpeople;
ArrayList<Agent> ambulanceboats;

void randomNetwork(float cull) {
  //  An example gridded network of width x height (pixels) and node resolution (pixels)
  //
  int nodeResolution = 10;  // pixels
  int graphWidth = width;   // pixels
  int graphHeight = height; // pixels
  network = new Graph(graphWidth, graphHeight, nodeResolution);
  landnetwork = new Graph(graphWidth,graphHeight, nodeResolution);
  network.cullRandom(cull); // Randomly eliminates a fraction of the nodes in the network (0.0 - 1.0)
}

void randomNetworkMinusBuildings(float cull, ArrayList<Polygon> poly) {
  //  An example gridded network of width x height (pixels) and node resolution (pixels)
  //
  int nodeResolution = 10;  // pixels
  int graphWidth = width;   // pixels
  int graphHeight = height; // pixels
  network = new Graph(graphWidth, graphHeight, nodeResolution);
  
  // An obstacle Course Based Upon Building Footprints
  //
  course = new ObstacleCourse();
  for (Polygon p: poly) {
    int numCorners = p.coordinates.size();
    PVector[] corners = new PVector[numCorners];
    for (int i=0; i<numCorners; i++) {
      PVector screenLocation = map.getScreenLocation(p.coordinates.get(i));
      corners[i] = new PVector(screenLocation.x, screenLocation.y);
    }
    Obstacle o = new Obstacle(corners);
    course.addObstacle(o);
  }
  
  // Subtract Building Footprints from Network
  //
  network.cullRandom(cull); // Randomly eliminates a fraction of the nodes in the network (0.0 - 1.0)
  network.applyObstacleCourse(course);
  
}

void waysNetwork(ArrayList<Way> w) {
  //  An example gridded network of width x height (pixels) and node resolution (pixels)
  //
  int nodeResolution = 7;  // pixels
  int graphWidth = width;   // pixels
  int graphHeight = height; // pixels
  network = new Graph(graphWidth, graphHeight, nodeResolution, w);
}
void landwaysNetwork(ArrayList<Way> w) {
  //  An example gridded network of width x height (pixels) and node resolution (pixels)
  //
  int nodeResolution = 7;  // pixels
  int graphWidth = width;   // pixels
  int graphHeight = height; // pixels
  landnetwork = new Graph(graphWidth, graphHeight, nodeResolution, w);
}

void landpoiPaths() {
  /*  An pathfinder object used to derive the shortest path. */
  finder = new Pathfinder(landnetwork);
  
  /*  Generate List of Shortest Paths through our network
   *  FORMAT 1: Path(float x, float y, float l, float w) <- defines 2 random points inside a rectangle
   *  FORMAT 2: Path(PVector o, PVector d) <- defined by two specific coordinates
   */
   
  landpaths = new ArrayList<Path>();
  for (int i=0; i<50; i++) {
    //  An example Origin and Desination between which we want to know the shortest path
    //
    PVector orig = new PVector(random(1.0)*width, random(1.0)*height); // Origin is Random Location
    
    // Destination is Random POI
    int dest_index = int(random(pois.size()));
    PVector dest = pois.get(dest_index).coord;
    dest = map.getScreenLocation(dest);
    
    Path d = new Path(orig, dest);
    d.solve(finder);
    landpaths.add(d);
  }
  
}

void bikeshoppoiPaths() {
  /*  An pathfinder object used to derive the shortest path. */
  finder = new Pathfinder(landnetwork);
  
  /*  Generate List of Shortest Paths through our network
   *  FORMAT 1: Path(float x, float y, float l, float w) <- defines 2 random points inside a rectangle
   *  FORMAT 2: Path(PVector o, PVector d) <- defined by two specific coordinates
   */
   
  bikeshoppaths = new ArrayList<Path>();
  //for (int i=0; i<50; i++) {
    //  An example Origin and Desination between which we want to know the shortest path
    orig = flat; // Origin is Random Location
    
    // Destination is Random POI
    dest = screenclosestshop;
    
    Path b = new Path(orig, dest);
    b.solve(finder);
    bikeshoppaths.add(b);
  //}
  
}

void poiPaths() {
  /*  An pathfinder object used to derive the shortest path. */
  finder = new Pathfinder(network);
  
  /*  Generate List of Shortest Paths through our network
   *  FORMAT 1: Path(float x, float y, float l, float w) <- defines 2 random points inside a rectangle
   *  FORMAT 2: Path(PVector o, PVector d) <- defined by two specific coordinates
   */
   
  paths = new ArrayList<Path>();
  for (int i=0; i<50; i++) {
    //  An example Origin and Desination between which we want to know the shortest path
int orig_index = int(random(waterpoint.size()));
    PVector orig = waterpoint.get(orig_index).coord;
    orig = map.getScreenLocation(orig);
    
    // Destination is Random POI
    int dest_index = int(random(waterpoint.size()));
    PVector dest = waterpoint.get(dest_index).coord;
    dest = map.getScreenLocation(dest);
    
    Path p = new Path(orig, dest);
    p.solve(finder);
    paths.add(p);
  }
  }
  
  void ambulanceboatpoiPaths() {
  /*  An pathfinder object used to derive the shortest path. */
  finder = new Pathfinder(network);
  
  /*  Generate List of Shortest Paths through our network
   *  FORMAT 1: Path(float x, float y, float l, float w) <- defines 2 random points inside a rectangle
   *  FORMAT 2: Path(PVector o, PVector d) <- defined by two specific coordinates
   */
   
  ambulanceboatpaths = new ArrayList<Path>();
  //for (int i=0; i<50; i++) {
    //  An example Origin and Desination between which we want to know the shortest path
    orig = closest;
    
    // Destination is Random POI
    dest = screenclosestcanal;
    
    Path w = new Path(orig, dest);
    w.solve(finder);
    ambulanceboatpaths.add(w);
  
}

void randomPaths() {
  /*  An pathfinder object used to derive the shortest path. */
  finder = new Pathfinder(network);
  
  /*  Generate List of Shortest Paths through our network
   *  FORMAT 1: Path(float x, float y, float l, float w) <- defines 2 random points inside a rectangle
   *  FORMAT 2: Path(PVector o, PVector d) <- defined by two specific coordinates
   */
   
  paths = new ArrayList<Path>();
  for (int i=0; i<50; i++) {
    //  An example Origin and Desination between which we want to know the shortest path
    //
    PVector orig = new PVector(random(1.0)*width, random(1.0)*height);
    PVector dest = new PVector(random(1.0)*width, random(1.0)*height);
    Path p = new Path(orig, dest);
    p.solve(finder);
    paths.add(p);
  }
  
}



void initPopulation(int count) {
  /*  An example population that traverses along various paths
  *  FORMAT: Agent(x, y, radius, speed, path);
  */
  people = new ArrayList<Agent>();
  for (int i=0; i<count; i++) {
    int random_index = int(random(paths.size()));
    Path random_path = paths.get(random_index);
    if (random_path.waypoints.size() > 1) {
      int random_waypoint = int(random(random_path.waypoints.size()));
      float random_speed = 0.3;
      PVector loc = random_path.waypoints.get(random_waypoint);
      Agent person = new Agent(loc.x, loc.y, 5, random_speed, random_path.waypoints);
      people.add(person);
    }
  }

}

void landinitPopulation(int count) {
  /*  An example population that traverses along various paths
  *  FORMAT: Agent(x, y, radius, speed, path);
  */
  
  landpeople = new ArrayList<Agent>();
  for (int i=0; i<count; i++) {
    int random_index = int(random(landpaths.size()));
    Path random_landpath = landpaths.get(random_index);
    if (random_landpath.waypoints.size() > 1) {
      int random_waypoint = int(random(random_landpath.waypoints.size()));
      float random_speed = 0.9;
      PVector loc = random_landpath.waypoints.get(random_waypoint);
      Agent landperson = new Agent(loc.x, loc.y, 5, random_speed, random_landpath.waypoints);
      landpeople.add(landperson);
    }
  }
}

void crashinitPopulation(int count) {
  /*  An example population that traverses along various paths
  *  FORMAT: Agent(x, y, radius, speed, path);
  */
  
  crashpeople = new ArrayList<Agent>();
  for (int i=0; i<count; i++) {
    int random_index = int(random(bikeshoppaths.size()));
    Path random_bikeshoppath = bikeshoppaths.get(random_index);
    if (random_bikeshoppath.waypoints.size() > 1) {
      int first_waypoint = 0;
      float random_speed = 0.9;
      PVector loc = random_bikeshoppath.waypoints.get(first_waypoint);
      Agent crashperson = new Agent(loc.x, loc.y, 5, random_speed, random_bikeshoppath.waypoints);
      crashpeople.add(crashperson);
    }
  }
}

void ambulanceboatinitPopulation(int count) {
  /*  An example population that traverses along various paths
  *  FORMAT: Agent(x, y, radius, speed, path);
  */
  ambulanceboats = new ArrayList<Agent>();
  for (int i=0; i<count; i++) {
    println(ambulanceboatpaths.size());
    int random_index = int(random(ambulanceboatpaths.size()));
    Path random_ambulanceboatpath = ambulanceboatpaths.get(random_index);
    if (random_ambulanceboatpath.waypoints.size() > 1) {
      int first_waypoint = 0;
      float random_speed = 1.5;
      PVector loc = random_ambulanceboatpath.waypoints.get(first_waypoint);
      Agent ambulanceboat = new Agent(loc.x, loc.y, 5, random_speed, random_ambulanceboatpath.waypoints);
      ambulanceboats.add(ambulanceboat);
    }
  }

}

ArrayList<PVector> personLocations(ArrayList<Agent> people) {
  ArrayList<PVector> l = new ArrayList<PVector>();
  for (Agent a: people) {
    l.add(a.location);
  }
  return l;
}
