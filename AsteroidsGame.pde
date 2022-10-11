Scene scene;
public void setup() {
    size(500, 500);
    scene = new Game();
    scene.setup();
}

public void draw() {
  if (scene.changeScene != null) {
    scene = scene.changeScene;
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
