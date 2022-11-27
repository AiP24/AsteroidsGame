class BasicBullet extends Sprite {
    protected double dmg; //I plan to extend this later
    public BasicBullet(int xCenter, int yCenter, int w, int h, float[] rXHitbox, float[] rYHitbox, int[] spriteColor, double direction, double dmg) {
        if (spriteColor.length != 3) {
            throw new IllegalArgumentException("spriteColor requires an array of length 3");
        }
        this.direction = direction;
        this.spriteColor = spriteColor;
        xHitbox = new int[rXHitbox.length];
        yHitbox = new int[rXHitbox.length];
        this.xCenter = xCenter;
        this.yCenter = yCenter;
        for (int v = 0; v < rXHitbox.length; v++) {
            xHitbox[v] = (int) Math.round((w/2.0)*rXHitbox[v]);
            yHitbox[v] = (int) Math.round((h/2.0)*rYHitbox[v]);
        }
        this.boundingBox = new int[] {-(w/2), -(h/2), w/2, h/2};
        this.dmg = dmg;
    }
    public void move() {
        xCenter += xVelocity;
        yCenter += yVelocity;
    }
    public boolean isOutOfBounds() {
        return xCenter < 0 || yCenter < 0 || xCenter > width || yCenter > height;
    }
    public boolean detectCollision(Sprite cmpSprite) {
        int[] cmpBBox = cmpSprite.getBBox();
        double cX = cmpSprite.getX();
        double cY = cmpSprite.getY();
        double minX = boundingBox[0]+xCenter;
        double maxX = boundingBox[2]+xCenter;
        double minY = boundingBox[1]+yCenter;
        double maxY = boundingBox[3]+yCenter;
        double cmpX = cmpBBox[0]+cX;
        double cmpY = cmpBBox[1]+cY;
        double cmpH = cmpBBox[2]-cmpBBox[0];
        double cmpW = cmpBBox[3]-cmpBBox[1];
        return (minX < cmpX + cmpW &&
                cmpX < maxX &&
                minY < cmpY + cmpH &&
                cmpY < maxY);
    }
    public double getDamage() {
        return dmg;
    }
}
