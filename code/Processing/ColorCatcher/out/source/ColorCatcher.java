/* autogenerated by Processing revision 1293 on 2024-04-15 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class ColorCatcher extends PApplet {


int satelliteCount = 10;
// create an ArrayList<Satellite> to hold all the satellites
ArrayList<Satellite> satellites = new ArrayList<Satellite>();

boolean showSatellites = true;

// the central planet
Planet planet;

// start of sketch
public void setup() {

	// fill the entire screen
	/* size commented out by preprocessor */;
	// hi-res retina mode
	/* pixelDensity commented out by preprocessor */;
	
	// instatiate the planet
	String filename = "hexagons-2024-04-11_01.svg";
	planet = new Planet(min(width, height) * 0.25f, filename);

	// instatiate the satellites
	for(int i=0; i<satelliteCount; i++) {
		satellites.add(new Satellite(i));
	}

}

// main loop
public void draw() {
	
	float hue = map((millis()*0.1f) % 1000, 0, 1000, 0, 360);
	colorMode(HSB, 360, 100, 100);
	background(hue, 0, 100);

	// draw the planet
	planet.draw();

	// draw all the satellites
	for (Satellite satellite : satellites) {
		satellite.move();
		satellite.draw();
	}
	
}


public void keyPressed() {

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
// The Planet class represents the central hexagonal shape in the middle of the screen

class Planet {

    float radius;
    PShape shape;

    Planet(float radius, String filename) {
        this.radius = radius;
        shape = loadShape(filename);
    }

    // draw the planet
    public void draw() {

        strokeWeight(2);

        pushMatrix();
        translate(width*0.5f,height*0.5f);

        // colorMode(HSB, 360, 100, 100, 100);
        // noFill();
        // stroke(0);
        // shape(shape, 100, 100, width, height);

        colorMode(RGB, 255, 255, 255, 255);
        noFill();
        stroke(0, 0, 50, 100);
        
        circle(0, 0, radius * 2);

        popMatrix();
    }

}
// the Satellite class contains behavior of objects that are satellites spinning around the central planet
// rockets in the shape of color pencils follow the movements of the satellites

enum RocketState {
	Dead,
	Targetting,
	Hovering,
	Retreating,
	Attacking
};

class Satellite {

	int index = -1;
	float hue, saturation, brightness; // color
	float proximityDistance = 100;

	PVector satellitePosition, rocketPosition, rocketTarget;
	float satelliteAngle, rocketAngle;
	float radius, speed, rocketThrust, direction;
	float xCenter, yCenter;

	RocketState rocketState = RocketState.Dead;

	Satellite(int index) {

		this.index = index;

		satellitePosition = new PVector(0, 0);
		rocketPosition = new PVector(0, 0);

		// theindex determines the radius of the satellite around the central planet
		// given the planet's radius is 0.25 of min(width, height), the satellite's radius is 0.25 + the position of the satellite in the array
		// depending on the number of satellites, the range will be i/10 of the remaining space around the planet (approx 0.5 of min(width, height))
		float startRadius = 0.3f * min(width, height);
		float remainingRadius = 0.2f * min(width, height);
		this.radius = startRadius + (index * (remainingRadius / PApplet.parseFloat(satelliteCount)));

		this.satelliteAngle = random(360);
		this.speed = random(0.1f, 0.5f);
		this.direction = random(1) > 0.5f ? 1 : - 1;

		this.rocketThrust = this.speed * 7.5f;
	}


	public void createRocket() { // (hue, saturation, brightness)

		// calculate the radius from center screen to a corner
		float cornerRadius = sqrt(sq(width * 0.5f) + sq(height * 0.5f));

		// therocket position starts as a projection out from center of the planet to the edge of the screen
		// using the angle of the satellite, the rocket position is calculated as a point on the edge of the screen.
		// We'll start by placing the rocket at the center
		this.rocketPosition = calculateScreenEdgeTarget();

		// setthe angle of the rocket to the angle of the satellite
		this.rocketAngle = atan2(this.satellitePosition.y - this.rocketPosition.y, this.satellitePosition.x - this.rocketPosition.x);

		// seta random color (only 8 possible hues)
		hue = random(8) * 45;

		rocketState = RocketState.Targetting;

	}


	public PVector calculateScreenEdgeTarget() {
		
		// calculate the radius from center screen to a corner
		float cornerRadius = sqrt(sq(width * 0.5f) + sq(height * 0.5f));

		// therocket position starts as a projection out from center of the planet to the edge of the screen
		// using the angle of the satellite, the rocket position is calculated as a point on the edge of the screen.
		// We'll start by placing the rocket at the center
		PVector target = new PVector(width * 0.5f, height * 0.5f);
		// nowproject out to edge of screen
		target.x += (this.radius + (cornerRadius - this.radius)) * cos(radians(this.satelliteAngle));
		target.y += (this.radius + (cornerRadius - this.radius)) * sin(radians(this.satelliteAngle));

		return target;

	}


	public void repelRocket() {

		if (rocketState == RocketState.Dead) {
			println("Can't repel rocket #" + index + " in state " + rocketState);
			return;
		}

		rocketState = RocketState.Retreating;
		rocketTarget = calculateScreenEdgeTarget();
		println("Rocket #" + index + " retreating to " + rocketTarget);

	}


	public void rocketAttack() {

		if (rocketState == RocketState.Dead || rocketState == RocketState.Targetting) {
			println("Can't attack with rocket #" + index + " in state " + rocketState);
			return;
		}

		rocketState = RocketState.Attacking;
		rocketTarget = new PVector(width * 0.5f, height * 0.5f);
		println("Rocket #" + index + " attacking target at " + rocketTarget);

	}


	public void move() {

		moveSatellite();
		moveRocket();
	}


	public void moveSatellite() {

		// get the distance of the rocket to this satellite
		float distance = dist(this.rocketPosition.x, this.rocketPosition.y, this.satellitePosition.x, this.satellitePosition.y);

		// if the rocket is hovering
		if ((rocketState == RocketState.Hovering || rocketState == RocketState.Targetting) && distance < proximityDistance) {
			// change state to Hovering if it isn't already
			rocketState = RocketState.Hovering;
			// increment angle
			this.satelliteAngle += this.speed * this.direction;
			// loop around 360 degrees
			this.satelliteAngle += 360;
			this.satelliteAngle %= 360;
		}

		// the satellite moves in a circle around the center of the screen
		this.satellitePosition.x = (width * 0.5f)  + this.radius * cos(radians(this.satelliteAngle));
		this.satellitePosition.y = (height * 0.5f) + this.radius * sin(radians(this.satelliteAngle));

	}


	public void moveRocket() {

		// start by targetting the center of the screen
		PVector targetPoint = new PVector(width*0.5f, height*0.5f);

		switch(rocketState) {
				
			case Dead:
				return;

			case Targetting:
			case Hovering:
				targetPoint.x = this.satellitePosition.x;
				targetPoint.y = this.satellitePosition.y;
				break;

			case Retreating:
				targetPoint.x = this.rocketTarget.x;
				targetPoint.y = this.rocketTarget.y;
				// if we've reached the target, the rocket is dead
				if (dist(targetPoint.x, targetPoint.y, this.rocketPosition.x, this.rocketPosition.y) < 20) {
					rocketState = RocketState.Dead;
				}
				break;

			case Attacking:
				targetPoint.x = this.rocketTarget.x;
				targetPoint.y = this.rocketTarget.y;
				float attackDistance = dist(targetPoint.x, targetPoint.y, this.rocketPosition.x, this.rocketPosition.y);
				// if we've reached the target, the rocket is dead
				if (attackDistance < 20) {
					rocketState = RocketState.Dead;
				}
				//println("Rocket #" + index + "\tcurrent position: " + this.rocketPosition + "\tattacking target at:" + targetPoint + "\tdistance:" + attackDistance);
				break;

		}

		// movetowards the target
		float targetAngle = 0;
		// calculatethe angle to the target
		targetAngle = atan2(targetPoint.y - this.rocketPosition.y, targetPoint.x - this.rocketPosition.x);
		// calculatethe angle difference
		float angleDiff = targetAngle - this.rocketAngle;
		// makesurethe angle difference is between -PI and PI
		if (angleDiff >	PI) angleDiff -= TWO_PI;
		if (angleDiff < - PI) angleDiff += TWO_PI;
		// limitthe angle difference to the maximum turn rate
		angleDiff = constrain(angleDiff, -0.1f, 0.1f);
		// updatethe angle
		this.rocketAngle += angleDiff;
		// updatethe position
		this.rocketPosition.x += cos(this.rocketAngle) * this.rocketThrust;
		this.rocketPosition.y += sin(this.rocketAngle) * this.rocketThrust;

	}


	public void draw() {

		if (showSatellites) {
			drawSatellite();
		}
		drawRocket();
	}


	public void drawSatellite() {

		// thesatellite is drawn as a circle with a radius of 0.05 of min(width, height)
		float satelliteRadius = 20;
		stroke(0, 100, 0, 100);
		noFill();
		strokeWeight(1);
		circle(this.satellitePosition.x, this.satellitePosition.y, satelliteRadius);

	}


	public void drawRocket() {

		if (rocketState == RocketState.Dead) {
			return;
		}

		//draw the rocket
		pushMatrix();
		translate(this.rocketPosition.x, this.rocketPosition.y);
		rotate(this.rocketAngle);
		// setcolor
		colorMode(HSB, 360, 100, 100);
		noStroke();
		fill(hue, 100, 100);
		// draw shape
		beginShape();
		// itsort of is a cross between a rocket and a pencil
		float tip = 5;
		float body = 10;
		// start at tip
		vertex(5, 0);
		vertex(0, tip);
		vertex( -body, 5);
		vertex( -body, -5);
		vertex(0, -5);
		vertex(5, 0);
		// close the shape at the tip where we started
		endShape(CLOSE);
		popMatrix();

	}
}


  public void settings() { fullScreen();
pixelDensity(2); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ColorCatcher" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}