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

class MainMenu extends Scene {
private String[] titleList;
private String[] splashList;
private String title;
private String splash;
private Button startButton;
private Button touhouButton;
private Popup splashText;
public MainMenu() {
titleList = new String[]{
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
splashList = new String[]{
"No Lunatic?",
};
}
public void setup() {
title = "Asteroids:\n" + titleList[(int)(Math.random()*titleList.length)];
splash = splashList[(int)(Math.random()*splashList.length)];
startButton = new Button(width/2, (int)(height*.6), height/12, "Start", new int[]{255, 255, 255}, new int[]{90, 215, 255});
touhouButton = new Button(width/2, (int)(height*.8), height/12, "Touhou Mode", new int[]{255, 255, 255}, new int[]{90, 215, 255});
splashText = new Popup(width/2, (int)(height*.9), height/24, splash, new int[]{255,255,255}, 3000, 1000);
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
changeScene = new Game(true);
}
}
}
class Game extends Scene {
private boolean up, down, left, right, shoot, shift, enter;
private boolean died;
private boolean touhouMode;
private ArrayList<BasicBullet> bulletList = new ArrayList<BasicBullet>();
private ArrayList<BasicAsteroid> asteroidList = new ArrayList<BasicAsteroid>();
private BasicShip ship;
private BasicEnemy enem;
private Button restartButton;
private Button mainMenuButton;
private ParticleSystem backgroundParticles;
public Game() {
up = down = left = right = shoot = shift = enter = false;
died = false;
touhouMode = false;
//bulletList = new ArrayList<>();
//asteroidList = new ArrayList<>();
backgroundParticles = new ParticleSystem(width/100, width/50, width/100, width/30, 90, 50, new int[]{200,200,200});
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
ship = new ImageShip(250, 400, 50, 50, s1x, s1y, "reimu", 5, 0);
enem = new BasicEnemy(250, 100, 50, 50, new float[]{0f, 1f, -1f}, new float[]{-1f, 1f, 1f}, new int[]{150, 239, 255}, 500);
} else {
ship = new BasicShip(250, 400, 50, 50, s1x, s1y, s1c, 0);
enem = new BasicEnemy(250, 100, 50, 50, new float[]{0f, 1f, -1f}, new float[]{-1f, 1f, 1f}, new int[]{150, 239, 255}, 500);
}
enem.turn(90);  
restartButton = new Button(width/2, height/2, height/15, "Restart (Enter)", new int[]{255, 255, 255}, new int[]{90, 215, 255});
mainMenuButton = new Button(width/2, (int)(height*.75), height/15, "Main Menu", new int[]{255, 255, 255}, new int[]{90, 215, 255});
}
public void draw() {
/* data processing */
if (!died) {
backgroundParticles.update();
enem.tickAttack();
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
if (shoot && globalTimer.timerDone("shotCooldown")) {
double[] sc = ship.getCannon();
BasicBullet b = new BasicBullet((int)(sc[0]), (int)(sc[1]), 50, 2, new float[]{-1, -1, 1, 1, -1}, new float[]{-1,1,1,-1, -1}, new int[]{250,255,255}, ship.direction, 10);
b.accelerate(15);
bulletList.add(b);
globalTimer.addTimer("shotCooldown", 200);
}
ship.move();
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
}
if (graze) {
ship.setColor(255, 255, 0);
} else {
ship.resetColor();
}
for (int i = 0; i < bulletList.size(); i++) {
bulletList.get(i).move();
if (bulletList.get(i).isOutOfBounds()) {
bulletList.remove(i);
i--;//fix indexing
}
else if (bulletList.get(i).detectCollision(enem)) {
enem.damage(bulletList.get(i).dmg);
if (enem.hitpoints <= 0) {
  //System.out.println("ded");
  
}
bulletList.remove(i);
i--;//fix indexing
}
else {
for (int a=0; a<asteroidList.size(); a++) {
  BasicAsteroid ast = asteroidList.get(a);
  if (bulletList.get(i).detectCollision(ast)) {
    asteroidList.remove(a);
    a--;
    bulletList.remove(i);
    i--;//fix indexing
    break;
  }
}
}
}
} else {
if (enter) {
//System.out.println("re");
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
enter = pressed;
ship.stop();
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
//System.out.println("re");
changeScene = new Game(touhouMode);
}
if (!pressed && died && mainMenuButton.isClicked(x, y)) {
//System.out.println("mm");
changeScene = new MainMenu();
}
}
}
