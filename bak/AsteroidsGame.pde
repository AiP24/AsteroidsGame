Scene scene;
Timer globalTimer;
//variable to test scope and stuff
String test = "beans";
public void setup() {
    size(500, 500);
    globalTimer = new Timer();
    scene = new MainMenu();
    scene.setup();
}

public void draw() {
  if (scene.sceneChanged()) {
    scene = scene.getNewScene();
    scene.setup();
  }
  scene.draw();
}

public void keyPressed() {
  scene.keyEvent((key == CODED) ? keyCode : key, true);
}
public void keyReleased() {
  scene.keyEvent((key == CODED) ? keyCode : key, false);
}
public void mousePressed() {
  scene.mouseEvent(mouseX, mouseY, true);
}
public void mouseReleased() {
  scene.mouseEvent(mouseX, mouseY, false);
}
