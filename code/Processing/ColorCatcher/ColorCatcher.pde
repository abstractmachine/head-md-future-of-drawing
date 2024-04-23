
int satelliteCount = 10;
// create an ArrayList<Satellite> to hold all the satellites
ArrayList<Satellite> satellites = new ArrayList<Satellite>();

boolean showSatellites = false;

// the central planet
Planet planet;

// start of sketch
void setup() {

	// fill the entire screen
	fullScreen();
	// hi-res retina mode
	pixelDensity(2);
	// anti-aliasing
	smooth();
	
	// instatiate the planet
	//String filename = "planet-001.svg";
	String filename = "planet-001-a.svg";
	planet = new Planet(min(width, height) * 0.4, filename);

	// instatiate the satellites
	for(int i=0; i<satelliteCount; i++) {
		satellites.add(new Satellite(i));
	}

	// start with blank background
	colorMode(RGB, 255, 255, 255, 255);
	background(210, 255);

}

// main loop
void draw() {
	
	noCursor();

	float hue = map((millis()*0.1) % 1000, 0, 1000, 0, 360);
	colorMode(RGB, 255, 255, 255, 255);
	noStroke();
	fill(255,50);
	rect(-1,-1,width+2,height+2);

	// draw the planet
	planet.draw();

	// draw all the satellites
	for (Satellite satellite : satellites) {
		satellite.move();
		satellite.draw();
	}
	
}


void keyPressed() {

	if (key == ' ') {
		showSatellites = !showSatellites;
	}

	if (key >= '0' && key <= '9') {
		int index = key - '0';
		if (index < satellites.size()) {
			satellites.get(index).createRocket();
		}
	}

	if (key >= 'a' && key <= 'z') {
		int index = key - 'a';
		if (index < satellites.size()) {
			satellites.get(index).rocketAttack();
		}
	}

	if (key >= 'A' && key <= 'Z') {
		int index = key - 'A';
		if (index < satellites.size()) {
			satellites.get(index).repelRocket();
		}
	}

}