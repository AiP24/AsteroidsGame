import java.util.List;
class BasicShip extends Sprite {
    protected int cannonId; //hitbox vertex that bullets come from
    public BasicShip(int xCenter, int yCenter, int w, int h, float[] rXHitbox, float[] rYHitbox, int[] spriteColor, int cannonId) {
        if (spriteColor.length != 3) {
            throw new IllegalArgumentException("spriteColor requires an array of length 3");
        }
        direction = 270; //upwards
        this.spriteColor = spriteColor;
        this.baseColor = spriteColor;
        xHitbox = new int[rXHitbox.length];
        yHitbox = new int[rXHitbox.length];
        this.xCenter = xCenter;
        this.yCenter = yCenter;
        for (int v = 0; v < rXHitbox.length; v++) {
            xHitbox[v] = (int) Math.round((w/2.0)*rXHitbox[v]);
            yHitbox[v] = (int) Math.round((h/2.0)*rYHitbox[v]);
        }
        this.boundingBox = new int[] {-(w/2), -(h/2), w/2, h/2};
        this.cannonId = cannonId;
    }

    public void setColor(int r, int g, int b) {
        spriteColor = new int[] {r,g,b};
    }
    public void resetColor() {
        spriteColor = baseColor;
    }

    public void stop() {
        xVelocity = 0;
        yVelocity = 0;
    }
    
    public void hyperspace() {
        stop();
        direction = 360*Math.random();
        xCenter = width*Math.random();
        yCenter = height*Math.random();
    }

    public void xStrafe(double amount) {
        xVelocity += amount;
    }
    public void yStrafe(double amount) {
        yVelocity += amount;
    }

    private Object arrayMax(List l) {
        Object max = null;
        for (int i = 0; i < l.size(); i++) {
            if (max == null || (double)max < (double)l.get(i)) {
                max = l.get(i);
            }
        }
        return max;
    }
    private Object arrayMin(List l) {
        Object min = null;
        for (int i = 0; i < l.size(); i++) {
            if (min == null || (double)min > (double)l.get(i)) {
                min = l.get(i);
            }
        }
        return min;
    }

    public double[] getCannon() {
        double dist = Math.sqrt(Math.pow(xHitbox[cannonId], 2)+Math.pow(yHitbox[cannonId], 2));
        double angle;
        try {
            angle = direction+degrees((float)Math.atan((double)(yHitbox[cannonId])/(double)(xHitbox[cannonId])));
        } catch (ArithmeticException e) {
            angle = direction+90;
        }
        if (xHitbox[cannonId] < 0 && yHitbox[cannonId] >= 0) {
            angle += 180;
        } else if (xHitbox[cannonId] < 0 && yHitbox[cannonId] < 0) {
            angle += 180;
        } else if (xHitbox[cannonId] >= 0 && yHitbox[cannonId] < 0) {
            angle += 90;
        } else {
            angle += 0;
        }

        return new double[] {xCenter + (dist * Math.cos(radians((float)angle))), yCenter + (dist * Math.sin(radians((float)angle)))};
        //fill(0, 255, 0, 50);
        //ellipse((float)(double)realXVertexes.get(v), (float)(double)realYVertexes.get(v), 10, 10);
    }
    public boolean detectCollision(Sprite cmpSprite, boolean graze) {
        List<Double> realXVertexes = new ArrayList<Double>();
        List<Double> realYVertexes = new ArrayList<Double>();
        for (int v = 0; v < xHitbox.length; v++) {
            double dist = Math.sqrt(Math.pow(xHitbox[v], 2)+Math.pow(yHitbox[v], 2));
            double angle;
            try {
                angle = direction+degrees((float)Math.atan((double)(yHitbox[v])/(double)(xHitbox[v])));
            } catch (ArithmeticException e) {
                angle = direction+90;
            }
            if (xHitbox[v] < 0 && yHitbox[v] >= 0) {
                angle += 180;
            } else if (xHitbox[v] < 0 && yHitbox[v] < 0) {
                angle += 180;
            } else if (xHitbox[v] >= 0 && yHitbox[v] < 0) {
                angle += 90;
            } else {
                angle += 0;
            }

            realXVertexes.add(xCenter + (dist * Math.cos(radians((float)angle))));
            realYVertexes.add(yCenter + (dist * Math.sin(radians((float)angle))));
            //fill(0, 255, 0, 50);
            //ellipse((float)(double)realXVertexes.get(v), (float)(double)realYVertexes.get(v), 10, 10);
        }
        int[] cmpBBox = cmpSprite.getBBox();
        double cX = cmpSprite.getX();
        double cY = cmpSprite.getY();
        double minX = (double)arrayMin(realXVertexes)-((boundingBox[2]-boundingBox[0])*.2);
        double minY = (double)arrayMin(realYVertexes)-((boundingBox[3]-boundingBox[1])*.2);
        double maxX = (double)arrayMax(realXVertexes)+((boundingBox[2]-boundingBox[0])*.2);
        double maxY = (double)arrayMax(realYVertexes)+((boundingBox[3]-boundingBox[1])*.2);
        double cmpX = cmpBBox[0]+cX;
        double cmpY = cmpBBox[1]+cY;
        double cmpH = cmpBBox[2]-cmpBBox[0];
        double cmpW = cmpBBox[3]-cmpBBox[1];
        //System.out.println(minX + " " + minY + " " + maxX + " " + maxY);
        fill(0, 255, 0, 50);
        rect((float)minX, (float)minY, (float)(maxX-minX), (float)(maxY-minY));
        if (
            minX < cmpX + cmpW &&
            cmpX < maxX &&
            minY < cmpY + cmpH &&
            cmpY < maxY
        ) {
            //complex collision testing
            for (int v = 0; v < realXVertexes.size(); v++) {
                double realX = realXVertexes.get(v);
                double realY = realYVertexes.get(v);
                if (realX >= cmpX && realX <= cmpX + cmpW &&
                        realY >= cmpY && realY <= cmpY + cmpH) {
                    return true && (!graze);
                }
            }
            return graze;
        }
        return false;
    }
}

class ImageShip extends BasicShip {
    private PImage[] spriteImage;
    private int animCount;
    public ImageShip(int xCenter, int yCenter, int w, int h, float[] rXHitbox, float[] rYHitbox, String spriteImage, int animCount, int cannonId) {
        super(xCenter, yCenter, w, h, rXHitbox, rYHitbox, new int[] {0, 0, 0}, cannonId);
        this.spriteImage = new PImage[animCount];
        for (int i=0; i<animCount; i++) {
            this.spriteImage[i] = loadImage(spriteImage+"_"+i+".png");
            this.spriteImage[i].resize(0, h);
        }
        this.animCount = animCount;
    }
    public void render() {
        pushMatrix();
        fill(0, 0, 0, 0);
        stroke(spriteColor[0], spriteColor[1], spriteColor[2]);
        translate((float) xCenter, (float) yCenter);
        rotate(radians((float)direction+90));
        //BROKEN IN PJS
        PImage im = spriteImage[frameCount/7%animCount];
        image(im, im.width/-2, im.height/-2);
        popMatrix();
    }
}
