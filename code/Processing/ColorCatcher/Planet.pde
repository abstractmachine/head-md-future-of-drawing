// The Planet class represents the central hexagonal shape in the middle of the screen

class Planet {

    float x, y, radius;

    Planet(float x, float y, float radius) {
        this.x = x;
        this.y = y;
        this.radius = radius;
    }

    // draw the planet
    void draw() {

        colorMode(HSB, 360, 100, 100, 100);

        fill(0, 0, 100, 100);
        stroke(0, 0, 50, 100);
        strokeWeight(2);
        circle(x, y, radius * 2);
    }

}