abstract class Scene {
  Scene changeScene;
  public abstract void setup();
  public abstract void draw();
  public abstract void keyEvent(int keyValue, boolean pressed);
  public abstract void mouseEvent(int x, int y, boolean pressed);
}

class MainMenu extends Scene {
  public MainMenu() {
  }
  public void setup() {
  }
  public void draw() {
  }
  public void keyEvent(int keyValue, boolean pressed) {
  }
  public void mouseEvent(int x, int y, boolean pressed) {
  }
}
class Game extends Scene {
  boolean up = false;
  boolean down = false;
  boolean left = false;
  boolean right = false;
  boolean shoot = false;
  boolean shift = false;
  ArrayList<BasicBullet> bulletList = new ArrayList<>();
  BasicShip ship;
  BasicShip enem;
  BasicAsteroid ast;
  public Game() {
  }
  public void setup() {
    float[] s1x = {1f, -.5f, -1f, -.5f};
    float[] s1y = {0f, -1f, 0f, 1f};
    int[] s1c = {255, 100, 100};
    ship = new BasicShip(250, 300, 50, 50, s1x, s1y, s1c);
    //enem = new BasicShip(250, 250, 50, 50, new float[]{0f, 1f, -1f}, new float[]{-1f, 1f, 1f}, new int[]{150, 239, 255});
    ast = new CurvedAsteroid(100, 100, 50, 50, new int[] {255, 255, 255}, .25);
    ast.turn(Math.random()*46);
    ast.accelerate(5);
  }
  public void draw() {
    background(32, 0, 102);
    if (up && shift) {
      ship.yStrafe(-.02);
    } else if (down && shift) {
      ship.yStrafe(.02);
    } else if (up) {
      ship.accelerate(.1);
    } else if (down) {
      ship.accelerate(-.08);
    }
    if (shift && left) {
      ship.xStrafe(-.05);
    } else if (shift && right) {
      ship.xStrafe(.05);
    } else if (left) {
      ship.turn(-5);
    } else if (right) {
      ship.turn(5);
    }
      ship.move();
    ship.render();
    //ast.turn(1);
    ast.move();
    ast.render();
    //enem.render();
    if (ship.detectCollision(ast, true) && !ship.detectCollision(ast, false)) {
      ship.setColor(255, 255, 0);
    } else if (ship.detectCollision(ast, false)) {
      ship.setColor(255, 0, 0);
      //enem.turn(69420);
    } else {
      ship.setColor(255, 100, 100);
    }
    for (int i = 0; i < bulletList.size(); i++) {
      bulletList.get(i).move();
      bulletList.get(i).render();
      if (bulletList.get(i).detectCollision(ast)) {
        ast.turn(180);
        bulletList.remove(i);
        i--;//fix indexing
      }
      else if (bulletList.get(i).isOutOfBounds()) {
        bulletList.remove(i);
        i--;//fix indexing
      }
    }
    /*for (int i = 0; i < bulletList.size(); i++) {
      bulletList.get(i).move();
      bulletList.get(i).render();
      if (bulletList.get(i).detectCollision(enem)) {
        enem.turn(5);
        bulletList.remove(i);
        i--;//fix indexing
      }
      else if (bulletList.get(i).isOutOfBounds()) {
        bulletList.remove(i);
        i--;//fix indexing
      }
    }*/
    //System.out.print(ship.detectCollision(enem, true));
    //System.out.println(" grazin");
    //System.out.print(ship.detectCollision(enem, false));
    //System.out.println(" hittin");
    //System.out.println();
  }
  public void keyEvent(int keyValue, boolean pressed) {
    switch (keyValue) {
      case UP:
      case 'w':
        up = pressed;
        break;
      case DOWN:
      case 's':
        down = pressed;
        break;
      case LEFT:
      case 'a':
        left = pressed;
        break;
      case RIGHT:
      case 'd':
        right = pressed;
        break;
      case ENTER:
      case RETURN:
        ship.stop();
        break;
      case SHIFT:
        shift = pressed;
        break;
      case ' ':
        shoot = pressed;
        if (!shoot) {
          BasicBullet b = new BasicBullet((int)ship.xCenter, (int)ship.yCenter, 50, 2, new float[]{-1, -1, 1, 1, -1}, new float[]{-1,1,1,-1, -1}, new int[]{250,255,255}, ship.direction);
          b.accelerate(15);
          bulletList.add(b);
        }
        break;
    }
  }
  public void mouseEvent(int x, int y, boolean pressed) {
  }
}
