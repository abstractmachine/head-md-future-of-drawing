// pointer to the canvas
let cnv;
// which planet we are currently showing
let planetIndex = 0;
// show the current state of the satellites
let showSatellites = false;
// 
let satelliteCount = 5;
//
let explosions = [];

function setup() {

	// fullscreen canvas
	cnv = createCanvas(windowWidth, windowHeight);
	cnv.parent('#p5');
	// load the first file from the list of planets
	loadPlanet(planetIndex);

	colorMode(HSB, 360, 100, 100, 100);
	background(0,0,0,100);

	// instatiate the satellites
	for(let i=0; i<satelliteCount; i++) {
		satellites.push(new Satellite(i));
	}

	// for each satellite
	satellites.forEach((satellite) => {
		// create a rocket
		satellite.createRocket();
	});

	noCursor();

}


// if window resized
function windowResized() {

	// resize canvas
	resizeCanvas(windowWidth, windowHeight);

}


// draw loop
function draw() {

	noCursor();

	// clear the canvas with a black background with opacity
	colorMode(RGB, 255, 255, 255, 255);
	noStroke();
	fill(0,50);
	rect(-1,-1,width+2,height+2);

	// for testing purposes
	// drawAlignement();

	// draw all the satellites
	satellites.forEach((satellite) => {
		satellite.move();
		satellite.draw();
	});

    // draw all the explosions
    explosions.forEach((explosion) => {
		explosion.draw();
        // if it's time to get rid of the explosion
        if (explosion.active === false) {
            // remove it from the list
            explosions = explosions.filter((exp) => exp !== explosion);
            return;
        }
	});
	
}


function keyPressed() {

	if (keyCode >= 65 && keyCode <= 75) {
		let index = keyCode - 65;
		if (index < satellites.length) {
			satellites[index].rocketAttack();
		}
	}

	if (keyCode >= 49 && keyCode <= 57) {
		let index = keyCode - 49;
		if (index < satellites.length) {
			satellites[index].createRocket();
		}
	}

}


// this helps us align the planet proportionally in the canvas
function drawAlignement() {

	// no stroke
	stroke(0,100,100);
	translate(width*0.5, height*0.5);
	line(-width*0.5, 0, width*0.5, 0);
	line(0, -height*0.5, 0, height*0.5);
	line(+width*0.165, -height*0.5, +width*0.165, height*0.5);
	line(-width*0.165, -height*0.5, -width*0.165, height*0.5);
	line(-width*0.5, -width*0.165, width*0.5, -width*0.165);
	line(-width*0.5, +width*0.165, width*0.5, +width*0.165);

}
