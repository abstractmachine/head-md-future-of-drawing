// The Planet class represents the central hexagonal shape in the middle of the screen

class Planet {

    float radius;
    PShape shape;

    Planet(float radius, String filename) {
        this.radius = radius;
        shape = loadShape(filename);
    }

    // draw the planet
    void draw() {

        strokeWeight(2);

        pushMatrix();
        translate(width*0.5,height*0.5);

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