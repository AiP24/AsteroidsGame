class HomingAsteroid extends BasicAsteroid {
  Sprite target;
  public HomingAsteroid(int xCenter, int yCenter, int w, int h, int[] spriteColor, double rotationVelocity, Sprite target) {
    super(xCenter, yCenter, w, h, spriteColor, rotationVelocity);
    this.target = target;
  }
  public void move() {
    turn(rotationVelocity);
    if (target.xCenter > xCenter) {
      xVelocity = Math.abs(xVelocity);
    } else {
      xVelocity = -Math.abs(xVelocity);
    }
    if (target.yCenter < yCenter) {
      yVelocity = -Math.abs(yVelocity);
    } else {
      yVelocity = Math.abs(yVelocity);
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
