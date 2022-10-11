import java.util.List;
import java.util.Collections;
class BasicShip extends Sprite {
    public BasicShip(int xCenter, int yCenter, int w, int h, double[] rXHitbox, double[] rYHitbox, int[] spriteColor) {
        if (spriteColor.length != 3) {
            throw new IllegalArgumentException("spriteColor requires an array of length 3");
        }
        direction = 90; //upwards
        this.spriteColor = spriteColor;
        xHitbox = new int[rXHitbox.length];
        yHitbox = new int[rXHitbox.length];
        this.xCenter = xCenter;
        this.yCenter = yCenter;
        for (int v = 0; v < rXHitbox.length; v++) {
            xHitbox[v] = (int) Math.round((w/2.0)*rXHitbox[v]);
            yHitbox[v] = (int) Math.round((h/2.0)*rYHitbox[v]);
        }
        this.boundingBox = new int[]{-(w/2), -(h/2), w/2, h/2};
    }
    
    public void setColor(int r, int g, int b) {
      spriteColor = new int[]{r,g,b};
    }
    
    public void stop() {
      xVelocity = 0;
      yVelocity = 0;
    }

    public void shoot() {
        //TODO: write me
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
        double minX = Collections.min(realXVertexes);
        double minY = Collections.min(realYVertexes);
        double maxX = Collections.max(realXVertexes);
        double maxY = Collections.max(realYVertexes);
        double cmpX = cmpSprite.boundingBox[0]+cmpSprite.xCenter;
        double cmpY = cmpSprite.boundingBox[1]+cmpSprite.yCenter;
        double cmpH = cmpSprite.boundingBox[2]-cmpSprite.boundingBox[0];
        double cmpW = cmpSprite.boundingBox[3]-cmpSprite.boundingBox[1];
        //System.out.println(minX + " " + minY + " " + maxX + " " + maxY);
        //fill(0, 255, 0, 50);
        //rect((float)minX, (float)minY, (float)(maxX-minX), (float)(maxY-minY));
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
