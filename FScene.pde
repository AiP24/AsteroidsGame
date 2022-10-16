abstract class Scene {
  Scene changeScene;
  public abstract void setup();
  public abstract void draw();
  public abstract void keyEvent(int keyValue, boolean pressed);
  public abstract void mouseEvent(int x, int y, boolean pressed);
}

class MainMenu extends Scene {
    String[] titleList = new String[]{
      "Highly Responsive to Asteroids",
      "Story of Asteroid Wonderland",
      "Phantasmagoria of Ast. Eroid",
      "Asteroid Land Story",
      "Mystic Asteroid",
      "Embodiment of Scarlet Asteroid",
      "Perfect Asteroid",
      "Immaterial and Missing Asteroid",
      "Imperishable Asteroid",
      "Phantasmagoria of Asteroid View",
      "Shoot the Asteroid",
      "Mountain of Asteroid",
      "Scarlet Asteroid Rhapsody",
      "Subterranean Asteroid",
      "Undefined Fantastic Asteroid",
      "Asteroid Hisoutensoku",
      "Double Asteroid",
      "Asteroid Wars",
      "Ten Asteroids",
      "Hopeless Asteroid",
      "Double Dealing Asteroid",
      "Impossible Asteroid Card",
      "Asteroid Legend in Limbo",
      "Legacy of Lunatic Asteroid",
      "Antinomy of Common Asteroids",
      "Hidden Star in Four Asteroids",
      "Asteroid Detector",
      "Wily Asteroid and Weakest Asteroid",
      "Asteroid Gouyoku Ibun",
      "Unconnected Asteroids"
    };
  String title;
  Button startButton;
  public MainMenu() {
  }
  public void setup() {
    title = "Asteroids:\n" + titleList[(int)(Math.random()*titleList.length)];
    startButton = new Button(width/2, (int)(height*.75), height/12, "Start", new int[]{255, 255, 255}, new int[]{90, 215, 255});
  }
  public void draw() {
    background(10, 0, 25);
    fill(255, 255, 255);
    textSize(3*width/title.length());
    textAlign(CENTER);
    text(title, width/2, height*.25);
    fill(0, 0, 0, 0);
    stroke(255, 255, 255);
    startButton.render();
    
  }
  public void keyEvent(int keyValue, boolean pressed) {
  }
  public void mouseEvent(int x, int y, boolean pressed) {
    if (!pressed && startButton.isClicked(x, y)) {
      //System.out.println("sg");
      changeScene = new Game();
    }
  }
}
class Game extends Scene {
  boolean up = false;
  boolean down = false;
  boolean left = false;
  boolean right = false;
  boolean shoot = false;
  boolean shift = false;
  boolean died = false;
  boolean enter = false;
  ArrayList<BasicBullet> bulletList = new ArrayList<BasicBullet>();
  BasicShip ship;
  BasicShip enem;
  BasicAsteroid ast;
  Button restartButton;
  Button mainMenuButton;
  public Game() {
  }
  public void setup() {
    float[] s1x = {1f, -.5f, -1f, -.5f};
    float[] s1y = {0f, -.5f, 0f, .5f};
    int[] s1c = {255, 100, 100};
    ship = new BasicShip(250, 400, 50, 50, s1x, s1y, s1c);
    //enem = new BasicShip(250, 250, 50, 50, new float[]{0f, 1f, -1f}, new float[]{-1f, 1f, 1f}, new int[]{150, 239, 255});
    ast = new HomingAsteroid(250, 250, 50, 50, new int[] {255, 255, 255}, 1, ship);
    ast.turn(45);
    ast.accelerate(Math.sqrt(2));
    restartButton = new Button(width/2, height/2, height/15, "Restart (Enter)", new int[]{255, 255, 255}, new int[]{90, 215, 255});
    mainMenuButton = new Button(width/2, (int)(height*.75), height/15, "Main Menu", new int[]{255, 255, 255}, new int[]{90, 215, 255});

  }
  public void draw() {
    /* data processing */
    if (!died) {
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
      ast.move();
      if (ship.detectCollision(ast, true) && !ship.detectCollision(ast, false)) {
        ship.setColor(255, 255, 0);
      } else if (ship.detectCollision(ast, false)) {
        ship.setColor(255, 0, 0);
        died = true;
        //enem.turn(69420);
      } else {
        ship.setColor(255, 100, 100);
      }
      for (int i = 0; i < bulletList.size(); i++) {
        bulletList.get(i).move();
        if (bulletList.get(i).detectCollision(ast)) {
          ast = new HomingAsteroid(250, 250, 50, 50, new int[] {255, 255, 255}, 1, ship);
          ast.turn(45);
          ast.accelerate(Math.sqrt(2));
          bulletList.remove(i);
          i--;//fix indexing
        }
        else if (bulletList.get(i).isOutOfBounds()) {
          bulletList.remove(i);
          i--;//fix indexing
        }
      }
    } else {
      if (enter) {
        //System.out.println("re");
        changeScene = new Game();
      }
    }
    /* rendering */
    background(10, 0, 25);
    ast.render();
    ship.render();
    for (int i = 0; i < bulletList.size(); i++) {
        bulletList.get(i).render();
    }
    if (died) {
      fill(255, 0, 0, 50);
      noStroke();
      rect(0, 0, width, height);
      fill(255, 255, 255);
      textSize(width/"You Died!".length());
      textAlign(CENTER);
      text("You Died!", width/2, height*.25);
      fill(0, 0, 0);
      stroke(255, 255, 255);
      restartButton.render();
      fill(0, 0, 0);
      stroke(255, 255, 255);
      mainMenuButton.render();
    }
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
      case '\\':
        enter = pressed;
        ship.stop();
        break;
      case SHIFT:
        shift = pressed;
        break;
      case ' ':
        shoot = pressed;
        if (!shoot && !died) {
          BasicBullet b = new BasicBullet((int)ship.xCenter, (int)ship.yCenter, 50, 2, new float[]{-1, -1, 1, 1, -1}, new float[]{-1,1,1,-1, -1}, new int[]{250,255,255}, ship.direction);
          b.accelerate(15);
          bulletList.add(b);
        }
        break;
    }
  }
  public void mouseEvent(int x, int y, boolean pressed) {
    if (!pressed && restartButton.isClicked(x, y)) {
      //System.out.println("re");
      changeScene = new Game();
    }
    if (!pressed && mainMenuButton.isClicked(x, y)) {
      //System.out.println("mm");
      changeScene = new MainMenu();
    }
  }
}
