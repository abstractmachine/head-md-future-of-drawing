// basic Processing (java) sketch with setup and draw functions

// create svg variable (java)
PShape svg;

void setup() {
	size(512, 512);
	svg = loadShape("inline-shapes-example.svg");
	println(svg.getChildCount());
	for(int i=0; i<svg.getChildCount(); i++){
		PShape child = svg.getChild(i);
		println(child.getName());
	}
}

void draw() {
	background(255);

	// loop through all the shapes
	for (int i = 0; i < svg.getChildCount(); i++) {
		PShape child = svg.getChild(i);
		// draw the shape
		shape(child, 0, 0, 512, 512);
	}
	shape(svg, 0, 0, 512, 512);
}
