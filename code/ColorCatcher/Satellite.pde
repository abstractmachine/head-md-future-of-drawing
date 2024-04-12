// the Satellite class contains behavior of objects that are satellites spinning around the central planet

class Satellite {

    float x, y, radius, angle, speed, direction;
  
    Satellite(int index) {

        // the index determines the radius of the satellite around the central planet
        // given the planet's radius is 0.25 of min(width, height), the satellite's radius is 0.25 + the position of the satellite in the array
        // depending on the number of satellites, the range will be i/10 of the remaining space around the planet (approx 0.5 of min(width, height))
        float startRadius = 0.4 * min(width,height);
        float remainingRadius = 0.25 * min(width,height);
        this.radius = startRadius + (index * (remainingRadius / 10.0));

        this.x = width * 0.5;
        this.y = height * 0.5;
        this.angle = random(360);
        this.speed = random(0.1, 0.5);
        this.direction = random(1) > 0.5 ? 1 : -1;
    }

    void draw() {
            
            // the satellite is drawn as a circle with a radius of 0.05 of min(width, height)
            float satelliteRadius = 20;
            float satelliteX = this.x + this.radius * cos(radians(this.angle));
            float satelliteY = this.y + this.radius * sin(radians(this.angle));

            this.angle += this.speed * this.direction;
            // loop around 360 degrees
            this.angle += 360;
            this.angle %= 360;
    
            fill(0,100,100,100);
            noStroke();
            circle(satelliteX, satelliteY, satelliteRadius);
    }

}