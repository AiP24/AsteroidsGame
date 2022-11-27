//REPLACES STARS IN THE TEMPLATE
class ParticleSystem {
  private Particle[] particles;
  public ParticleSystem(int minSize, int maxSize, double minVelocity, double maxVelocity, double direction, int particleCount, int[] particleColor ) {
    particles = new Particle[particleCount];
    for (int i=0;i<particleCount;i++) {
      particles[i] = new Particle((int)(Math.random()*width), (int)(Math.random()*height), (int)(minSize+Math.random()*(maxSize-minSize)), minVelocity+Math.random()*(maxVelocity-minVelocity), direction, particleColor);
    }
  }
  public void update() {
    for (int i=0;i<particles.length;i++) {
      particles[i].move();
    }
  }
  public void render() {
    for (int i=0;i<particles.length;i++) {
      particles[i].render();
    }
  }
}
class Particle {
  private int x, y;
  private int size;
  private double velocity;
  private double direction;
  private int[] particleColor;
  public Particle(int x, int y, int size, double velocity, double direction, int[] particleColor) {
    this.x=x;
    this.y=y;
    this.size=size;
    this.velocity=velocity;
    this.direction=direction;
    this.particleColor=particleColor;
  }
  public void move() {
    x += (int)(Math.cos(radians((float)direction))*velocity);
    y += (int)(Math.sin(radians((float)direction))*velocity);
    if (x > width) x=0;
    else if (x < 0) x=width;
    if (y > height) y=0;
    else if (y < 0) y=height;
  }
  public void render() {
    fill(particleColor[0], particleColor[1], particleColor[2]); //add opacity
    noStroke();
    ellipse(x, y, size, size);
  }
}
