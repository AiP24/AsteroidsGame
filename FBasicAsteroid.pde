class BasicAsteroid extends Sprite{
  public int vertexCount;
  public double rotationVelocity;
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
          System.out.println(xHitbox[v]);
          System.out.println(yHitbox[v]);
      }
      this.boundingBox = new int[]{-(w/2), -(h/2), w/2, h/2};
      System.out.println(this.boundingBox);
  }
  public void move() {
    turn(rotationVelocity);
    super.move();
  }
    public void render() {
        pushMatrix();
        translate((float) xCenter, (float) yCenter);
        fill(0, 255, 0, 50);
        rect(boundingBox[0], boundingBox[1], boundingBox[2]*2, boundingBox[3]*2);
        rotate(radians((float)direction));
        fill(spriteColor[0], spriteColor[1], spriteColor[2]);
        stroke(spriteColor[0], spriteColor[1], spriteColor[2]);
        beginShape(POLYGON);
        for (int v = 0; v < xHitbox.length; v++) {
            vertex(xHitbox[v], yHitbox[v]);
        }
        endShape();
        
    popMatrix();

    }
}
