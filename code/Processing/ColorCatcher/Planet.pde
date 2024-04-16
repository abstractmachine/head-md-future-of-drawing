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

        // for(int i=0; i<shape.getChildCount(); i++) {
        //     PShape child = shape.getChild(i);
        //     // if there is no content
        //     if (child.getChildCount() == 0) continue;
        //     //shape(child, 0, 0, radius, radius);
        //     for(int j=0; j<child.getChildCount(); j++) {
        //         PShape grandchild = child.getChild(j);
        //         println(grandchild.getChildCount());
        //         shape(grandchild, 0, 0, radius, radius);
        //     }
        //     //println(child.getChildCount());
        // }

        shape(shape, 0, 0, radius, radius);

        popMatrix();
    }

    // check if a point is inside the planet
    boolean pixelInPoly(PVector[] verts, PVector pos) {

        int i, j;
        boolean c=false;
        int sides = verts.length;

        for (i=0,j=sides-1; i<sides; j=i++) {
            if (( ((verts[i].y <= pos.y) && (pos.y < verts[j].y)) || ((verts[j].y <= pos.y) && (pos.y < verts[i].y))) &&
            (pos.x < (verts[j].x - verts[i].x) * (pos.y - verts[i].y) / (verts[j].y - verts[i].y) + verts[i].x)) {
                c = !c;
            }
        }
        return c;
    }

    // // check if a point is inside the planet
    // String isInside(PVector pos) {
        
    //     for(int i=0; i<shape.getChildCount(); i++) {

    //         PShape child = shape.getChild(i);

    //         PVector[] verts = new PVector[child.getVertexCount()];
    //         for(int j=0; j<child.getVertexCount(); j++) {
    //             PVector vert = child.getVertex(j);
    //             verts[j] = new PVector(vert.x, vert.y);
    //         }

    //         if(pixelInPoly(verts, pos)) {
    //             return true;
    //         }
    //     }
    // }

}