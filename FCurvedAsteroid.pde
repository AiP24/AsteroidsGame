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
