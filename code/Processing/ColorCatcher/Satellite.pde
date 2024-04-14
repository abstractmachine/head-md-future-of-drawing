// the Satellite class contains behavior of objects that are satellites spinning around the central planet
// rockets in the shape of color pencils follow the movements of the satellites

enum RocketState {
	Dead,
	Hover,
	Retreat,
	Attack
};

class Satellite {

	float hue, saturation, brightness; // color

	PVector satellitePosition, rocketPosition;
	float satelliteAngle, rocketAngle;
	float radius, speed, rocketThrust, direction;
	float xCenter, yCenter;

	RocketState rocketState = RocketState.Dead;

	Satellite(int index) {

		satellitePosition = new PVector(0, 0);
		rocketPosition = new PVector(0, 0);

		// theindex determines the radius of the satellite around the central planet
		// given the planet's radius is 0.25 of min(width, height), the satellite's radius is 0.25 + the position of the satellite in the array
		// depending on the number of satellites, the range will be i/10 of the remaining space around the planet (approx 0.5 of min(width, height))
		float startRadius = 0.4 * min(width, height);
		float remainingRadius = 0.25 * min(width, height);
		this.radius = startRadius + (index * (remainingRadius / 10.0));

		this.satelliteAngle = random(360);
		this.speed = random(0.1, 0.5);
		this.direction = random(1) > 0.5 ? 1 : - 1;

		this.rocketThrust = this.speed * 7.5;
	}


	void createRocket() { // (hue, saturation, brightness)

		// calculate the radius from center screen to a corner
		float cornerRadius = sqrt(sq(width * 0.5) + sq(height * 0.5));

		// therocket position starts as a projection out from center of the planet to the edge of the screen
		// using the angle of the satellite, the rocket position is calculated as a point on the edge of the screen.
		// We'll start by placing the rocket at the center
		this.rocketPosition = new PVector(width * 0.5, height * 0.5);
		// nowproject out to edge of screen
		this.rocketPosition.x += (this.radius + (cornerRadius - this.radius)) * cos(radians(this.satelliteAngle));
		this.rocketPosition.y += (this.radius + (cornerRadius - this.radius)) * sin(radians(this.satelliteAngle));

		// setthe angle of the rocket to the angle of the satellite
		this.rocketAngle = atan2(this.satellitePosition.y - this.rocketPosition.y, this.satellitePosition.x - this.rocketPosition.x);

		// seta random color (only 8 possible hues)
		hue = random(8) * 45;

		rocketState = RocketState.Hover;

	}


	void repelRocket() {
	}


	void rocketAttack() {
	}


	void move() {

		moveSatellite();
		moveRocket();
	}


	void moveSatellite() {

		// get the distance of the rocket to this satellite
		float distance = dist(this.rocketPosition.x, this.rocketPosition.y, this.satellitePosition.x, this.satellitePosition.y);

		// if the rocket is hovering
		if (rocketState == RocketState.Hover && distance < 50) {
			// increment angle
			this.satelliteAngle += this.speed * this.direction;
			// loop around 360 degrees
			this.satelliteAngle += 360;
			this.satelliteAngle %= 360;
		}

		// the satellite moves in a circle around the center of the screen
		this.satellitePosition.x = (width * 0.5)  + this.radius * cos(radians(this.satelliteAngle));
		this.satellitePosition.y = (height * 0.5) + this.radius * sin(radians(this.satelliteAngle));

	}


	void moveRocket() {

		switch(rocketState) {
				
			case Dead:
				// donothing
				break;

			case Hover:

				// movetowards the target
				// calculatethe angle to the target
				float targetAngle = atan2(this.satellitePosition.y - this.rocketPosition.y, this.satellitePosition.x - this.rocketPosition.x);
				// calculatethe angle difference
				float angleDiff = targetAngle - this.rocketAngle;
				// makesurethe angle difference is between -PI and PI
				if (angleDiff >	PI) angleDiff -= TWO_PI;
				if (angleDiff < - PI) angleDiff += TWO_PI;
				// limitthe angle difference to the maximum turn rate
				angleDiff = constrain(angleDiff, -0.1, 0.1);
				// updatethe angle
				this.rocketAngle += angleDiff;
				// updatethe position
				this.rocketPosition.x += cos(this.rocketAngle) * this.rocketThrust;
				this.rocketPosition.y += sin(this.rocketAngle) * this.rocketThrust;

				break;

			case Retreat:
				// donothing
				break;

			case Attack:
				break;

		}
	}


	void draw() {

		if (showSatellites) {
			drawSatellite();
		}
		drawRocket();
	}


	void drawSatellite() {

		// thesatellite is drawn as a circle with a radius of 0.05 of min(width, height)
		float satelliteRadius = 20;
		stroke(0, 100, 0, 100);
		noFill();
		strokeWeight(1);
		circle(this.satellitePosition.x, this.satellitePosition.y, satelliteRadius);

	}


	void drawRocket() {

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
