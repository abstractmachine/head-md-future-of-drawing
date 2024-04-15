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
	float randomOffset = 0;
	float wanderStrength = 0.25;
	float wanderSpeed = 0.05;

	RocketState rocketState = RocketState.Dead;

	Satellite(int index) {

		this.index = index;

		// to keep each Perlin noise value unique, we'll add a random offset to the index
		this.randomOffset = random(1000);

		satellitePosition = new PVector(0, 0);
		rocketPosition = new PVector(0, 0);

		// theindex determines the radius of the satellite around the central planet
		// given the planet's radius is 0.25 of min(width, height), the satellite's radius is 0.25 + the position of the satellite in the array
		// depending on the number of satellites, the range will be i/10 of the remaining space around the planet (approx 0.5 of min(width, height))
		float startRadius = 0.4 * min(width, height);
		float remainingRadius = 0.2 * min(width, height);
		this.radius = startRadius + (index * (remainingRadius / float(satelliteCount)));

		this.satelliteAngle = random(360);
		this.speed = random(1.1, 1.5);
		this.direction = random(1) > 0.5 ? 1 : - 1;

		this.rocketThrust = this.speed * 1.5;
	}


	void createRocket() { // (hue, saturation, brightness)

		// calculate the radius from center screen to a corner
		float cornerRadius = sqrt(sq(width * 0.5) + sq(height * 0.5));

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


	PVector calculateScreenEdgeTarget() {
		
		// calculate the radius from center screen to a corner
		float cornerRadius = sqrt(sq(width * 0.5) + sq(height * 0.5));

		// therocket position starts as a projection out from center of the planet to the edge of the screen
		// using the angle of the satellite, the rocket position is calculated as a point on the edge of the screen.
		// We'll start by placing the rocket at the center
		PVector target = new PVector(width * 0.5, height * 0.5);
		// now project out to edge of screen
		target.x += (this.radius + (cornerRadius - this.radius)) * cos(radians(this.satelliteAngle));
		target.y += (this.radius + (cornerRadius - this.radius)) * sin(radians(this.satelliteAngle));

		return target;

	}


	void repelRocket() {

		if (rocketState == RocketState.Dead) {
			println("Can't repel rocket #" + index + " in state " + rocketState);
			return;
		}

		rocketState = RocketState.Retreating;
		rocketTarget = calculateScreenEdgeTarget();

	}


	void rocketAttack() {

		if (rocketState == RocketState.Dead || rocketState == RocketState.Targetting) {
			println("Can't attack with rocket #" + index + " in state " + rocketState);
			return;
		}

		rocketState = RocketState.Attacking;
		rocketTarget = new PVector(width * 0.5, height * 0.5);

	}


	void move() {

		moveSatellite();
		moveRocket();
	}


	void moveSatellite() {

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
		this.satellitePosition.x = (width * 0.5)  + this.radius * cos(radians(this.satelliteAngle));
		this.satellitePosition.y = (height * 0.5) + this.radius * sin(radians(this.satelliteAngle));

	}


	void moveRocket() {

		// start by targetting the center of the screen
		PVector targetPoint = new PVector(width*0.5, height*0.5);

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
		// calculatethe angle to the target
		float targetAngle = atan2(targetPoint.y - this.rocketPosition.y, targetPoint.x - this.rocketPosition.x);
		// calculatethe angle difference
		float angleDiff = targetAngle - this.rocketAngle;
		// makesurethe angle difference is between -PI and PI
		if (angleDiff >	PI) angleDiff -= TWO_PI;
		if (angleDiff < - PI) angleDiff += TWO_PI;

		switch(rocketState) {
			case Targetting:
				// add a little randomness to the targetting using perlin noise
				this.rocketAngle += map(noise(this.randomOffset + frameCount * wanderSpeed), 0, 1, -wanderStrength, wanderStrength);
				break;
			case Hovering:
				// add a little randomness to the targetting using perlin noise
				this.rocketAngle += map(noise(this.randomOffset + frameCount * wanderSpeed), 0, 1, -wanderStrength, wanderStrength);
				break;
		}
		
		// limitthe angle difference to the maximum turn rate
		angleDiff = constrain(angleDiff, -0.1, 0.1);
		// updatethe angle
		this.rocketAngle += angleDiff;
		// updatethe position
		this.rocketPosition.x += cos(this.rocketAngle) * this.rocketThrust;
		this.rocketPosition.y += sin(this.rocketAngle) * this.rocketThrust;

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
