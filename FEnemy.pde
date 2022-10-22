class Enemy extends Sprite {
  double hitpoints;
  public Enemy(int xCenter, int yCenter, int w, int h, float[] rXHitbox, float[] rYHitbox, int[] spriteColor, double hitpoints) {
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
    this.hitpoints = hitpoints;
  }
  public void damage(double val) {
    hitpoints -= val;
  }
}
