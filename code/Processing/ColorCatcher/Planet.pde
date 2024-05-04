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

        colorMode(HSB, 360, 100, 100, 100);
        noFill();
        stroke(0, 0, 0, 100);

        shape.disableStyle();
        shapeMode(CENTER);
        
        strokeWeight(2);
        strokeJoin(ROUND);

        shape(shape, 0, 0, 400, 400);
        popMatrix();

       /* for(int i=0; i<shape.getChildCount(); i++) {

            stroke((360/8*i), 100, 100, 100);

            PShape child = shape.getChild(i);
            // println(child.getKind());
            shape(child, 0, 0, 400, 400);

            beginShape();
            for(int j=0; j<child.getVertexCount(); j++) {
                PVector vert = child.getVertex(j);
                vertex(vert.x, vert.y);
            }
            endShape();
        }*/

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