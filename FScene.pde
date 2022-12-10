abstract class Scene {
//the Scene class is kind of a wrapper around Processing's builtin functions, to make it easy to switch program behavior on the fly, e.g. between menus and gameplay
    protected Scene changeScene;
    public abstract void setup();
    public abstract void draw();
//The default events are hard to use, so I made it a bit easier
    public abstract void keyEvent(int keyValue, boolean pressed);
    public abstract void mouseEvent(int x, int y, boolean pressed);
//check if the scene is ready to change, if so then getNewScene is expected
    public boolean sceneChanged() {
        return changeScene != null;
    }
    public Scene getNewScene() {
        return changeScene;
    }
}

class ControlsMenu extends Scene {
    private boolean up, down, left, right, shoot, shift, enter;
    private BasicShip moveShip, turnShip, shootShip, strafeShip, grazeShip, ship;
    private ArrayList<BasicBullet> bulletList = new ArrayList<BasicBullet>(); //I know you should initialize in the constructor but that breaks processing.js for no reason
    private Button exit; 

    public void setup() {        
        up = down = left = right = shoot = shift = enter = false;
        float[] s1x = {1f, -.5f, -1f, -.5f};
        float[] s1y = {0f, -.5f, 0f, .5f};
        int[] s1c = {150, 239, 255};
        moveShip = new BasicShip(width/5, height/10*3, 50, 50, s1x, s1y, s1c, 0);
        moveShip.accelerate(-1);
        turnShip = new BasicShip(width/4*3, height/5, 50, 50, s1x, s1y, s1c, 0);
        shootShip = new BasicShip(width/4*3, height/10*4, 50, 50, s1x, s1y, s1c, 0);
        shootShip.turn(45/2);
        strafeShip = new BasicShip(width/2, height/10*6, 50, 50, s1x, s1y, s1c, 0);
        grazeShip = new BasicShip(width/2, height/4*3, 50, 50, s1x, s1y, s1c, 0);
        grazeShip.setColor(255, 255, 0);
        exit = new Button(width/20, height/20, height/20, "Back", new int[] {255, 255, 255}, new int[] {90, 215, 255});
        
        ship = new BasicShip(width/2, height/10*8, 50, 50, s1x, s1y, new int[] {255, 100, 100}, 0);
    }
    public void draw() {
        if (up && shift) {
            ship.yStrafe(-.02);
        } else if (down && shift) {
            ship.yStrafe(.02);
        } else if (up) {
            ship.accelerate(.08);
        } else if (down) {
            ship.accelerate(-.08);
        }
        if (shift && left) {
            ship.xStrafe(-.05);
        } else if (shift && right) {
            ship.xStrafe(.05);
        } else if (left) {
            ship.turn(-3);
        } else if (right) {
            ship.turn(3);
        }
        ship.move();
        turnShip.turn(5*sin(PI*2/(60*5)*frameCount));
        moveShip.accelerate(.1*sin(PI*2/(60*5)*frameCount));
        strafeShip.xStrafe(.1*sin(PI*2/(60*5)*frameCount));
        moveShip.move();
        strafeShip.move();
        if (globalTimer.timerDone("demoShotCooldown")) {
            double[] sc = shootShip.getCannon();
            BasicBullet b = new BasicBullet((int)(sc[0]), (int)(sc[1]), 30, 1, new float[] {-1, -1, 1, 1, -1}, new float[] {-1,1,1,-1, -1}, new int[] {250,255,255}, shootShip.getDirection(), 10);
            b.accelerate(15);
            bulletList.add(b);
            globalTimer.addTimer("demoShotCooldown", 200);
        }
        for (int i = 0; i < bulletList.size(); i++) {
            bulletList.get(i).move();
            if (bulletList.get(i).isOutOfBounds()) {
                bulletList.remove(i);
                i--;//fix indexing
            }
        }
        if (shoot && globalTimer.timerDone("shotCooldown")) {
            double[] sc = ship.getCannon();
            BasicBullet b = new BasicBullet((int)(sc[0]), (int)(sc[1]), 30, 1, new float[] {-1, -1, 1, 1, -1}, new float[] {-1,1,1,-1, -1}, new int[] {250,255,255}, ship.getDirection(), 10);
            b.accelerate(15);
            bulletList.add(b);
            globalTimer.addTimer("shotCooldown", 150);
        }
        
        background(10, 0, 25);
        strokeWeight(2);
        stroke(255,255,255);
        exit.render();
        fill(255,255,255);
        textAlign(CENTER);
        textSize(width/20);
        text("How to play", width/2, height/10);
        textSize(width/40);
        text("A/Left and D/Right to turn", width/2, height/5);
        text("W/Up and S/Down to accelerate and decelerate", width/2, height/10*3);
        text("Space to shoot", width/2, height/10*4);
        text("Shift+direction to strafe in that direction", width/2, height/2);
        text("Enter/backslash/e for hyperspace", width/2, height/10*7);
        if ((ship.getX() == width/2 && ship.getY() == height/10*8)) {
            text("Try controlling me!", width/2, height/10*9);
        }
        turnShip.render();
        moveShip.render();
        shootShip.render();
        strafeShip.render();
        ship.render();
        
        for (int i = 0; i < bulletList.size(); i++) {
            bulletList.get(i).render();
        }
        
    }
    
    public void keyEvent(int keyValue, boolean pressed){
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
            case 'e':
                if (!pressed) { 
                    bulletList.clear();
                    ship.hyperspace();
                }
            case SHIFT:
                shift = pressed;
                break;
            case ' ':
                shoot = pressed;
                break;
        }
    }
    public void mouseEvent(int x, int y, boolean pressed){
        if (!pressed && exit.isClicked(x, y)) {
            changeScene = new MainMenu();
        }
    }
}

class MainMenu extends Scene {
    private String[] titleList;
    private String[] splashList;
    private String title;
    private String splash;
    private Button startButton;
    private Button touhouButton;
    private Popup splashText;
    public MainMenu() {
        titleList = new String[] {
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
        splashList = new String[] {
            "No Lunatic?",
        };
    }
    public void setup() {
        title = "Asteroids:\n" + titleList[(int)(Math.random()*titleList.length)];
        splash = splashList[(int)(Math.random()*splashList.length)];
        startButton = new Button(width/2, (int)(height*.6), height/12, "Start", new int[] {255, 255, 255}, new int[] {90, 215, 255});
        touhouButton = new Button(width/2, (int)(height*.8), height/12, "How to play", new int[] {255, 255, 255}, new int[] {90, 215, 255});
        splashText = new Popup(width/2, (int)(height*.9), height/24, splash, new int[] {255,255,255}, 3000, 1000);
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
        fill(0, 0, 0, 0);
        stroke(255, 255, 255);
        touhouButton.render();
        splashText.render();
    }
    public void keyEvent(int keyValue, boolean pressed) {
        if (keyValue == ENTER || keyValue == RETURN && !pressed) {
//System.out.println("sg");
            changeScene = new Game();
        }
    }
    public void mouseEvent(int x, int y, boolean pressed) {
        if (!pressed && startButton.isClicked(x, y)) {
//System.out.println("sg");
            changeScene = new Game();
        } else if (!pressed && touhouButton.isClicked(x, y)) {
//System.out.println("sg");
            changeScene = new ControlsMenu();
        }
    }
}
class Game extends Scene {
    private boolean up, down, left, right, shoot, shift, enter;
    private boolean died, won;
    private boolean touhouMode;
    private ArrayList<BasicBullet> bulletList = new ArrayList<BasicBullet>(); //I know you should initialize in the constructor but that breaks processing.js for no reason
    private ArrayList<BasicAsteroid> asteroidList = new ArrayList<BasicAsteroid>(); //^
    private BasicShip ship;
    private BasicEnemy enem;
    private Button restartButton;
    private Button mainMenuButton;
    private Button continueButton;
    private ParticleSystem backgroundParticles;
    private int astDestroyCount;
    public Game() {
        up = down = left = right = shoot = shift = enter = false;
        died = false;
        won = false;
        touhouMode = false;
//bulletList = new ArrayList<>();
//asteroidList = new ArrayList<>();
        backgroundParticles = new ParticleSystem(uiScale/100, uiScale/50, uiScale/100, uiScale/30, 90, 100, new int[] {200,200,200});
        astDestroyCount = 0;
    }
    public Game(boolean touhou) {
        this();
        this.touhouMode = touhou;
    }
    public void setup() {
        float[] s1x = {1f, -.5f, -1f, -.5f};
        float[] s1y = {0f, -.5f, 0f, .5f};
        int[] s1c = {255, 100, 100};
        if (touhouMode) {
            ship = new ImageShip(width/2, 400, 50, 50, s1x, s1y, "reimu", 5, 0);
            enem = new BasicEnemy(width/2, 100, 50, 50, new float[] {0f, 1f, -1f}, new float[] {-1f, 1f, 1f}, new int[] {150, 239, 255}, 3000);
        } else {
            ship = new BasicShip(width/2, 400, 50, 50, s1x, s1y, s1c, 0);
            enem = new BasicEnemy(width/2, 100, 50, 50, new float[] {0f, 1f, -1f}, new float[] {-1f, 1f, 1f}, new int[] {150, 239, 255}, 3000);
        }
        enem.turn(90);
        restartButton = new Button(width/2, height/2, height/15, "Restart (Enter)", new int[] {255, 255, 255}, new int[] {90, 215, 255});
        continueButton = new Button(width/2, height/2, height/15, "Play Again (Enter)", new int[] {255, 255, 255}, new int[] {90, 215, 255});
        mainMenuButton = new Button(width/2, (int)(height*.75), height/15, "Main Menu", new int[] {255, 255, 255}, new int[] {90, 215, 255});
    }
    public void draw() {
        /* data processing */
        if (!died && !won) {
            backgroundParticles.update();
            enem.tickAttack();
            if (enter) {
            }
            if (up && shift) {
                ship.yStrafe(-.02);
            } else if (down && shift) {
                ship.yStrafe(.02);
            } else if (up) {
                ship.accelerate(.08);
            } else if (down) {
                ship.accelerate(-.08);
            }
            if (shift && left) {
                ship.xStrafe(-.05);
            } else if (shift && right) {
                ship.xStrafe(.05);
            } else if (left) {
                ship.turn(-3);
            } else if (right) {
                ship.turn(3);
            }
            ship.move();
            enem.move();
            for (int i=0; i<asteroidList.size(); i++) {
                asteroidList.get(i).move();
            }
            boolean graze = false;
            for (int i = 0; i < asteroidList.size(); i++) {
                if (ship.detectCollision(asteroidList.get(i), true) && !ship.detectCollision(asteroidList.get(i), false)) {
//ship.setColor(255, 255, 0);
                    graze = true;
                } else if (ship.detectCollision(asteroidList.get(i), false)) {
                    ship.setColor(255, 0, 0);
                    died = true;
                }
            }
            if (ship.detectCollision(enem, true) && !ship.detectCollision(enem, false)) {
                graze = true;
            } else if (ship.detectCollision(enem, false)) {
                ship.setColor(255, 0, 0);
                died = true;
            } else if (enem.getHitpoints() <= 0) {
                won = true;
            }
            if (graze) {
                ship.setColor(255, 255, 0);
            } else {
                ship.resetColor();
            }
            if (shoot && globalTimer.timerDone("shotCooldown")) {
                double[] sc = ship.getCannon();
                BasicBullet b = new BasicBullet((int)(sc[0]), (int)(sc[1]), 30, 1, new float[] {-1, -1, 1, 1, -1}, new float[] {-1,1,1,-1, -1}, new int[] {250,255,255}, ship.getDirection(), 10);
                b.accelerate(15);
                bulletList.add(b);
                if (graze) {
                    globalTimer.addTimer("shotCooldown", 75-(astDestroyCount/10));
                } else {
                    globalTimer.addTimer("shotCooldown", 150-(astDestroyCount/10));
                }
            }
            for (int i = 0; i < bulletList.size(); i++) {
                bulletList.get(i).move();
                if (bulletList.get(i).isOutOfBounds()) {
                    bulletList.remove(i);
                    i--;//fix indexing
                }
                else if (bulletList.get(i).detectCollision(enem)) {
                    enem.damage(bulletList.get(i).dmg);
                    if (enem.getHitpoints() <= 0) {
                        //System.out.println("ded");

                    }
                    bulletList.remove(i);
                    i--;//fix indexing
                }
                else if (bulletList.get(i).detectCollision(ship)) {
                    died = true;
                }
                else {
                    for (int a=0; a<asteroidList.size(); a++) {
                        BasicAsteroid ast = asteroidList.get(a);
                        if (bulletList.get(i).detectCollision(ast)) {
                            asteroidList.remove(a);
                            a--;
                            bulletList.remove(i);
                            i--;//fix indexing
                            astDestroyCount++;
                            break;
                        }
                    }
                }
            }
        } else  if (died) {
            if (enter) {
                changeScene = new Game(touhouMode);
            }
        } else if (won) {
            if (enter) {
                changeScene = new Game(touhouMode);
            }
        }
        /* rendering */
        strokeWeight(2);
        background(10, 0, 25);
        backgroundParticles.render();
        enem.render();
        for (int i=0; i<asteroidList.size(); i++) {
            asteroidList.get(i).render();
        }
        for (int i = 0; i < bulletList.size(); i++) {
            bulletList.get(i).render();
        }
        ship.render();
        if (died) {
            if (ship.detectCollision(enem, false)) {
                if (enem.getHitpoints() > 0) enem.damage(enem.getHitpoints());
                fill(255, 0, 0, 100);
                noStroke();
                rect(0, 0, width, height);
                fill(255, 255, 255);
                textSize(width/"You are a space terrorist".length());
                textAlign(CENTER);
                text("You are a space terrorist", width/2, height*.25);
            } else {
                fill(255, 0, 0, 50);
                noStroke();
                rect(0, 0, width, height);
                fill(255, 255, 255);
                if (enem.getHitpoints() == 3000) {
                    textSize(width/"L+Ratio+Skill Issue".length());
                    textAlign(CENTER);
                    text("L+Ratio+Skill Issue", width/2, height*.25);
                } else {
                    textSize(width/"You Died!".length());
                    textAlign(CENTER);
                    text("You Died!", width/2, height*.25);
                }
            }
            fill(0, 0, 0);
            stroke(255, 255, 255);
            restartButton.render();
            fill(0, 0, 0);
            stroke(255, 255, 255);
            mainMenuButton.render();
        }
        
        else if (won) {
            fill(255, 255, 255, 50);
            noStroke();
            rect(0, 0, width, height);
            fill(255, 255, 255);
            textSize(width/"Stage Complete!".length());
            textAlign(CENTER);
            text("Stage Complete!", width/2, height*.25);
            fill(0, 0, 0);
            stroke(255, 255, 255);
            continueButton.render();
            fill(0, 0, 0);
            stroke(255, 255, 255);
            mainMenuButton.render();
        } 
        else {
            fill(255, 255, 255);
            textAlign(LEFT);
            textSize(height*.03);
            text("Asteroids destroyed: "+astDestroyCount+" | Shot speed modifier: +"+(astDestroyCount/10), 0, height*.97);
        }
    }
    public ArrayList<BasicAsteroid> getAsteroids() {
        return asteroidList;
    }
    public BasicShip getShip() {
        return ship;
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
        case 'e':
            if (pressed) {
                enem.resetAttack();
                bulletList = new ArrayList<BasicBullet>();
                asteroidList = new ArrayList<BasicAsteroid>();
                ship.hyperspace();
                while(ship.detectCollision(enem, true) || ship.detectCollision(enem, false)) {
                    ship.hyperspace();
                }
            }
            enter = pressed;
            break;
        case SHIFT:
            shift = pressed;
            break;
        case ' ':
            shoot = pressed;
            break;
        }
    }
    public void mouseEvent(int x, int y, boolean pressed) {
        if (!pressed && died && restartButton.isClicked(x, y)) {
            changeScene = new Game(touhouMode);
        }
        if (!pressed && won && continueButton.isClicked(x, y)) {
            changeScene = new Game(touhouMode);
        }
        if (!pressed && (died || won) && mainMenuButton.isClicked(x, y)) {
            changeScene = new MainMenu();
        }
    }
}
