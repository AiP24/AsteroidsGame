abstract class Widget {
  int[] boundingBox;
  int xCenter;
  int yCenter;
  public boolean isClicked(int x, int y) {
    return boundingBox[0] <= x && x <= boundingBox[2] && boundingBox[1] <= y && y <= boundingBox[3];  
  }
  public abstract void onClick();
  public abstract void render();
}
