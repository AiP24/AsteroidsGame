//I didn't like the original floater class so I kind of had to modify it slightly
class Sprite {
    protected int[] boundingBox; //xy1 (top left), xy2 (bottom right)
    protected int[] xHitbox, yHitbox;
    protected double xCenter, yCenter;
    protected double xVelocity, yVelocity;
    protected double direction;
    protected int[] spriteColor; //more complex sprites may need more colors
    protected int[] baseColor; //unused?
    
    public int[] getBBox(){return boundingBox;}
    public double getX(){return xCenter;}
    public double getY(){return yCenter;}

    public void accelerate(double amount) {
        //convert the current direction the floater is pointing to radians
        double rads = direction * (Math.PI / 180);
        //change coordinates of direction of travel
        if (Math.abs(xVelocity) < 100)
            xVelocity += ((amount) * Math.cos(rads));
        if (Math.abs(yVelocity) < 100)
            yVelocity += ((amount) * Math.sin(rads));
    }

    public void turn(double rotationAmount) {
        direction += rotationAmount;
        direction = direction % 360.0;
        if (direction < 0) {
            direction = direction+360;
        }
    }

    public void move() {
        xCenter += xVelocity;
        yCenter += yVelocity;

        //wrap around screen
        if (xCenter > width) {
            xCenter = 0;
        }
        else if (xCenter < 0) {
            xCenter = width;
        }

        if (yCenter > height) {
            yCenter = 0;
        }
        else if (yCenter < 0) {
            yCenter = height;
        }
    }

    public void render() {
        pushMatrix();
        fill(0, 0, 0, 0);
        stroke(spriteColor[0], spriteColor[1], spriteColor[2]);
        translate((float) xCenter, (float) yCenter);
        rotate(radians((float)direction));
        beginShape(POLYGON);
        for (int v = 0; v < xHitbox.length; v++) {
            vertex(xHitbox[v], yHitbox[v]);
        }
        vertex(xHitbox[0], yHitbox[0]);
        endShape();
        popMatrix();

    }
}
