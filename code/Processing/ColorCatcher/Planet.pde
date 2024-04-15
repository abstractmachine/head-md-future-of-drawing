// The Planet class represents the central hexagonal shape in the middle of the screen

class Planet {

    float radius;
    PShape shape;

    Planet(float radius, String filename) {
        this.radius = radius;
        shape = loadShape(filename);
        shape.disableStyle();
    }

    // draw the planet
    void draw() {

        strokeWeight(2);

        pushMatrix();
        translate(width*0.5,height*0.5);

        shapeMode(CENTER);
        colorMode(HSB, 360, 100, 100, 100);
        noFill();
        stroke(0, 0, 0, 100);
        strokeWeight(2);
        shape(shape, 0, 0, radius, radius);

        popMatrix();
    }

}