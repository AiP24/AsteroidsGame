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
  BasicShip ship;
  BasicShip enem;
  public Game() {
  }
  public void setup() {
    ship = new BasicShip(250, 300, 50, 50, new double[]{1d, -.5d, -1d, -.5d}, new double[]{0d, -1d, 0d, 1d}, new int[]{255, 100, 100});
    enem = new BasicShip(250, 250, 50, 50, new double[]{0d, 1d, -1d}, new double[]{-1d, 1d, 1d}, new int[]{150, 239, 255});
  }
  public void draw() {
    background(0, 0, 0);
    if (up) {
      ship.accelerate(.2);
    } else if (down) {
      ship.accelerate(-.2);
    }
    if (left) {
      ship.turn(-5);
    } else if (right) {
      ship.turn(5);
    }
      ship.move();
    ship.render();
    enem.render();
    if (ship.detectCollision(enem, true) && !ship.detectCollision(enem, false)) {
      ship.setColor(255, 255, 0);
    } else if (ship.detectCollision(enem, false)) {
      ship.setColor(255, 0, 0);
    } else {
      ship.setColor(255, 100, 100);
    }
    System.out.print(ship.detectCollision(enem, true));
    System.out.println(" grazin");
    System.out.print(ship.detectCollision(enem, false));
    System.out.println(" hittin");
    System.out.println();
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
        ship.stop();
        break;
    }
  }
  public void mouseEvent(int x, int y, boolean pressed) {
  }
}
