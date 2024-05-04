// create an array to hold all the satellites
let satellites = [];

// the Satellite class contains behavior of objects that are satellites spinning around the central planet
// rockets in the shape of color pencils follow the movements of the satellites

const RocketState = {
	Dead: 0,
	Targetting: 1,
	Hovering: 2,
	Retreating: 3,
	Attacking: 4
};

class Satellite {

	constructor(index) {

		this.index = index;

		this.hue = 0;
		this.saturation = 100;
		this.brightness = 100;

		this.proximityDistance = 100;

		this.wanderStrength = 0.25;
		this.wanderSpeed = 0.05;

		// to keep each Perlin noise value unique, we'll add a random offset to the index
		this.randomOffset = Math.random() * 1000;

		this.satellitePosition = {x: 0, y: 0};
		this.rocketPosition = {x: 0, y: 0};
		this.rocketTarget = {x: 0, y: 0};

		// the index determines the radius of the satellite around the central planet
		// given the planet's radius is 0.25 of min(width, height), the satellite's radius is 0.25 + the position of the satellite in the array
		// depending on the number of satellites, the range will be i/10 of the remaining space around the planet (approx 0.5 of min(width, height))
		let startRadius = 0.5 * Math.min(window.innerWidth, window.innerHeight);
		let remainingRadius = 0.1 * Math.min(window.innerWidth, window.innerHeight);
		this.radius = startRadius + (index * (remainingRadius / satelliteCount));

		this.satelliteAngle = Math.random() * 360;
		this.speed = Math.random() * (1.5 - 1.1) + 1.1;
		this.direction = Math.random() > 0.5 ? 1 : - 1;

		this.rocketThrust = this.speed * 1.5;
		this.rocketAngle = 0;
		this.rocketState = RocketState.Dead;

	}


	createRocket() {
		// calculate the radius from center screen to a corner
		let cornerRadius = Math.sqrt(Math.pow(window.innerWidth * 0.5, 2) + Math.pow(window.innerHeight * 0.5, 2));
	
		// the rocket position starts as a projection out from center of the planet to the edge of the screen
		// using the angle of the satellite, the rocket position is calculated as a point on the edge of the screen.
		// We'll start by placing the rocket at the center
		this.rocketPosition = this.calculateScreenEdgeTarget(this.satelliteAngle);
	
		// set the angle of the rocket to the angle of the satellite
		this.rocketAngle = Math.atan2(this.satellitePosition.y - this.rocketPosition.y, this.satellitePosition.x - this.rocketPosition.x);
	
		// set a random color (only 8 possible hues)
		this.hue = Math.floor(Math.random() * 8) * 45;
	
		this.rocketState = RocketState.Targetting;
	}


	calculateScreenEdgeTarget(fromAngle) {
		// calculate the radius from center screen to a corner
		let cornerRadius = Math.sqrt(Math.pow(window.innerWidth * 0.5, 2) + Math.pow(window.innerHeight * 0.5, 2));
	
		// the rocket position starts as a projection out from center of the planet to the edge of the screen
		// using the angle of the satellite, the rocket position is calculated as a point on the edge of the screen.
		// We'll start by placing the rocket at the center
		let target = {x: window.innerWidth * 0.5, y: window.innerHeight * 0.5};
	
		// now project out to edge of screen
		target.x += (this.radius + (cornerRadius - this.radius)) * Math.cos(radians(this.satelliteAngle));
		target.y += (this.radius + (cornerRadius - this.radius)) * Math.sin(radians(this.satelliteAngle));
	
		return target;
	}


	repelRocket() {
		if (this.rocketState === RocketState.Dead) {
			// console.log("Can't repel rocket #" + this.index + " in state " + this.rocketState);
			return;
		}

		this.rocketState = RocketState.Retreating;
		// the rocket will retreat to the edge of the screen using its own angle for orientation
		this.rocketTarget = this.calculateScreenEdgeTarget(this.rocketAngle);
	}


	rocketAttack() {
		if (this.rocketState === RocketState.Dead || this.rocketState === RocketState.Targetting) {
			// console.log("Can't attack with rocket #" + this.index + " in state " + this.rocketState);
			return;
		}

		this.rocketState = RocketState.Attacking;
		this.rocketTarget = {x: window.innerWidth * 0.5, y: window.innerHeight * 0.5};

		// console.log("Rocket #" + this.index + " is attacking");
	}


	rocketExplode() {
		this.rocketState = RocketState.Dead;
		// create an explosion
		let explosion = new Explosion(this.rocketPosition.x, this.rocketPosition.y, this.hue, this.saturation, this.brightness);
		// add the explosion to the array
		explosions.push(explosion);
	}


	move() {

		this.moveSatellite();
		this.moveRocket();
		
	}


	moveSatellite() {
		// get the distance of the rocket to this satellite
		let distance = dist(this.rocketPosition.x, this.rocketPosition.y, this.satellitePosition.x, this.satellitePosition.y);

		// if the rocket is hovering
		if ((this.rocketState === RocketState.Hovering || this.rocketState === RocketState.Targetting) && distance < this.proximityDistance) {
			// change state to Hovering if it isn't already
			this.rocketState = RocketState.Hovering;
			// increment angle
			this.satelliteAngle += this.speed * this.direction;
			// loop around 360 degrees
			this.satelliteAngle += 360;
			this.satelliteAngle %= 360;
		}

		// the satellite moves in a circle around the center of the screen
		this.satellitePosition.x = (window.innerWidth * 0.5)  + this.radius * Math.cos(radians(this.satelliteAngle));
		this.satellitePosition.y = (window.innerHeight * 0.5) + this.radius * Math.sin(radians(this.satelliteAngle));
	}


	moveRocket() {
		// start by targeting the center of the screen
		let targetPoint = {x: window.innerWidth * 0.5, y: window.innerHeight * 0.5};

		switch(this.rocketState) {
			case RocketState.Dead:
				return;

			case RocketState.Targetting:
			case RocketState.Hovering:
				targetPoint.x = this.satellitePosition.x;
				targetPoint.y = this.satellitePosition.y;
				break;

			case RocketState.Attacking:
				targetPoint.x = this.rocketTarget.x;
				targetPoint.y = this.rocketTarget.y;
				// check to see if the point at the tip of this rocket is touching the planet
				// using the isInsidePlanet function from planet.js
				this.checkIntersection();
				break;

			case RocketState.Retreating:
				targetPoint.x = this.rocketTarget.x;
				targetPoint.y = this.rocketTarget.y;
				// if we've reached the target, the rocket is dead
				if (dist(targetPoint.x, targetPoint.y, this.rocketPosition.x, this.rocketPosition.y) < 20) {
					this.rocketExplode();
				}
				break;
		} 

		// move towards the target
		// calculate the angle to the target
		let targetAngle = Math.atan2(targetPoint.y - this.rocketPosition.y, targetPoint.x - this.rocketPosition.x);
		// calculate the angle difference
		let angleDiff = targetAngle - this.rocketAngle;
		// make sure the angle difference is between -PI and PI
		if (angleDiff > Math.PI) angleDiff -= Math.PI * 2;
		if (angleDiff < -Math.PI) angleDiff += Math.PI * 2;

		switch(this.rocketState) {
			case RocketState.Targetting:
			case RocketState.Hovering:
				// add a little randomness to the targeting using perlin noise
				this.rocketAngle += map(noise(this.randomOffset + frameCount * this.wanderSpeed), 0, 1, -this.wanderStrength, this.wanderStrength);
				break;
		}

		// limit the angle difference to the maximum turn rate
		angleDiff = Math.max(Math.min(angleDiff, 0.1), -0.1);
		// update the angle
		this.rocketAngle += angleDiff;
		// update the position
		this.rocketPosition.x += Math.cos(this.rocketAngle) * this.rocketThrust;
		this.rocketPosition.y += Math.sin(this.rocketAngle) * this.rocketThrust;
	}


	checkIntersection() {

		let pathOfIntersection = isPointInside({'x':this.rocketPosition.x, 'y':this.rocketPosition.y});

		if (pathOfIntersection) {

			// convert hsv to rgb
			let rgb = hsvToRgb(this.hue / 360.0, this.saturation / 100.0, this.brightness / 100.0);
			// get the color of this satellite and convert it to RGB
			// the color has to be converted to a string to be used in the color function
			let colorString = color(rgb[0], rgb[1], rgb[2]).toString();

			// check if there are any neighboring shapes
			let neighbors = checkNeighbours(pathOfIntersection, colorString);
			
			// send to the planet the path of intersection and the color of the satellite
			colorPlanetSegment(pathOfIntersection, colorString);
			// kill the rocket
			this.rocketExplode();

		}

	}


	draw() {
		if (showSatellites) {
			this.drawSatellite();
		}
		this.drawRocket();
	}


	drawSatellite() {
		// the satellite is drawn as a circle with a radius of 0.05 of min(width, height)
		let satelliteRadius = 20;
		// stroke, noFill, strokeWeight, and circle are p5.js functions
		// you need to include the p5.js library to use these functions
		colorMode(HSB, 360, 100, 100, 100);
		stroke(0, 0, 100, 100);
		noFill();
		strokeWeight(1);
		circle(this.satellitePosition.x, this.satellitePosition.y, satelliteRadius);
	}


	drawRocket() {

		// if the rocket is dead, don't draw it
		if (this.rocketState === RocketState.Dead) {
			return;
		}

		//draw the rocket
		push();
		translate(this.rocketPosition.x, this.rocketPosition.y);
		rotate(this.rocketAngle);
		// setcolor
		colorMode(HSB, 360, 100, 100);
		noStroke();
		fill(this.hue, this.saturation, this.brightness, 100);
		// draw shape
		beginShape();
		// it sort of is a cross between a rocket and a pencil
		let tip = 5;
		let body = 10;
		// start at tip
		vertex(5, 0);
		vertex(0, tip);
		vertex(-body, 5);
		vertex(-body, -5);
		vertex(0, -5);
		vertex(5, 0);
		// close the shape at the tip where we started
		endShape(CLOSE);
		pop();
	}


}
