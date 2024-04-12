
int satelliteCount = 10;
// create an ArrayList<Satellite> to hold all the satellites
ArrayList<Satellite> satellites = new ArrayList<Satellite>();

// the central planet
Planet planet;

// start of sketch
void setup() {

	fullScreen();
	
	// instatiate the planet
	planet = new Planet(width*0.5, height*0.5, min(width, height) * 0.25);

	// instatiate the satellites
	for(int i=0; i<satelliteCount; i++) {
		satellites.add(new Satellite(i));
	}

}

// main loop
void draw() {
	
	float hue = map((millis()*0.1) % 1000, 0, 1000, 0, 360);
	colorMode(HSB, 360, 100, 100);
	background(hue, 0, 100);

	// draw the planet
	planet.draw();

	// draw all the satellites
	for (Satellite satellite : satellites) {
		satellite.draw();
	}
	
}