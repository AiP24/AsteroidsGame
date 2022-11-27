class BasicAsteroid extends Sprite{
  protected int vertexCount;
  protected double rotationVelocity;
  public BasicAsteroid(int xCenter, int yCenter, int w, int h, int[] spriteColor, double direction, double rotationVelocity) {
    this(xCenter, yCenter, w, h, spriteColor, rotationVelocity);
    this.direction = direction;
  }
  public BasicAsteroid(int xCenter, int yCenter, int w, int h, int[] spriteColor, double rotationVelocity) {
      if (spriteColor.length != 3) {
          throw new IllegalArgumentException("spriteColor requires an array of length 3");
      }
      direction = 90; //upwards
      this.spriteColor = spriteColor;
      vertexCount = (int)(Math.random()*6+6);
      xHitbox = new int[vertexCount];
      yHitbox = new int[vertexCount];
      this.xCenter = xCenter;
      this.yCenter = yCenter;
      this.rotationVelocity = rotationVelocity;
      for (int v = 0; v < vertexCount; v++) {
          double randX = Math.cos(TWO_PI/(double)vertexCount*v) + (Math.random()*.3-.15);
          double randY = Math.sin(TWO_PI/(double)vertexCount*v) + (Math.random()*.3-.15);
          xHitbox[v] = (int) Math.round((w/2.0)*randX);
          yHitbox[v] = (int) Math.round((h/2.0)*randY);
          //System.out.println(xHitbox[v]);
          //System.out.println(yHitbox[v]);
      }
      this.boundingBox = new int[]{-(w/2-w/15), -(h/2-h/15), w/2-w/15, h/2-h/15};
      //System.out.println(this.boundingBox);
  }
  public void move() {
    turn(rotationVelocity);
    super.move();
  }
    public void render() {
        pushMatrix();
        translate((float) xCenter, (float) yCenter);
        fill(0, 255, 0, 50);
        //rect(boundingBox[0], boundingBox[1], boundingBox[2]*2, boundingBox[3]*2);
        rotate(radians((float)direction));
        fill(0, 0, 0, 0);
        stroke(spriteColor[0], spriteColor[1], spriteColor[2]);
        beginShape(POLYGON);
        for (int v = 0; v < xHitbox.length; v++) {
            vertex(xHitbox[v], yHitbox[v]);
        }
        vertex(xHitbox[0], yHitbox[0]);
        endShape();
        
    popMatrix();

    }
}
class HomingAsteroid extends BasicAsteroid {
  private Sprite target;
  private double speed;
  public HomingAsteroid(int xCenter, int yCenter, int w, int h, int[] spriteColor, double rotationVelocity, double speed, Sprite target) {
    super(xCenter, yCenter, w, h, spriteColor, rotationVelocity);
    this.target = target;
    this.speed = speed;
  }
  public void move() {
    turn(rotationVelocity);
    if (target.xCenter > xCenter) {
      xVelocity = Math.abs(speed/(Math.sqrt(2)));
    } else {
      xVelocity = -Math.abs(speed/(Math.sqrt(2)));
    }
    if (target.yCenter < yCenter) {
      yVelocity = -Math.abs(speed/(Math.sqrt(2)));
    } else {
      yVelocity = Math.abs(speed/(Math.sqrt(2)));
    }
    
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
}
class CurvedAsteroid extends BasicAsteroid {
  public CurvedAsteroid(int xCenter, int yCenter, int w, int h, int[] spriteColor, double rotationVelocity) {
    super(xCenter, yCenter, w, h, spriteColor, rotationVelocity);
  }
  public void move() {
    double velocity = Math.sqrt(yVelocity*yVelocity+xVelocity*xVelocity);
    xVelocity = Math.cos(radians((float)direction))*velocity;
    yVelocity = Math.sin(radians((float)direction))*velocity;
    super.move();
  }
}
