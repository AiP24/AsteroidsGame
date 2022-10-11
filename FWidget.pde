abstract class Widget {
  int[] boundingBox;
  int xCenter;
  int yCenter;
  public boolean clickHit(int x, int y) {
    return true;
  }
  public abstract void onClick();
  public abstract void render();
}
