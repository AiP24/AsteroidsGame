class BasicEnemy extends Sprite {
    protected double hitpoints;
    protected double maxHp;
    protected int phase;
    protected String staticHash;
    protected int subphase;
    public BasicEnemy(int xCenter, int yCenter, int w, int h, float[] rXHitbox, float[] rYHitbox, int[] spriteColor, double hitpoints) {
        if (spriteColor.length != 3) {
            throw new IllegalArgumentException("spriteColor requires an array of length 3");
        }
        direction = 90; //upwards
        this.spriteColor = spriteColor;
        xHitbox = new int[rXHitbox.length];
        yHitbox = new int[rXHitbox.length];
        this.xCenter = xCenter;
        this.yCenter = yCenter;
        for (int v = 0; v < rXHitbox.length; v++) {
            xHitbox[v] = (int) Math.round((w/2.0)*rXHitbox[v]);
            yHitbox[v] = (int) Math.round((h/2.0)*rYHitbox[v]);
        }
        this.boundingBox = new int[] {-(w/2), -(h/2), w/2, h/2};
        this.hitpoints = this.maxHp = hitpoints;
        this.staticHash = String.valueOf(this.hashCode());
        phase = subphase = 0;
    }
    public void move() {
        this.xCenter = (width/2)+(width/4)*sin((2*PI)/(60*4-13)*(frameCount));
    }
    public void damage(double val) {
        hitpoints -= val;
    }
    public double getHitpoints() {
        return hitpoints;
    }
    public void resetAttack() {
        phase = 0;
        subphase = 0;
    }
    public void render() {
        super.render();
        noFill();
        stroke(255,255,255);
        rect((float)(xCenter-boundingBox[2]*2.25), (float)(yCenter-boundingBox[3]*2.5), (float)(boundingBox[2]*4.5), (float)(boundingBox[3]/2));
        stroke(0,255,0);
        rect((float)(xCenter-boundingBox[2]*2.25), (float)(yCenter-boundingBox[3]*2.5), (float)(boundingBox[2]*4.5*(hitpoints/maxHp)), (float)(boundingBox[3]/2));
        //rect((float)(xCenter-(boundingBox[3])+(boundingBox[3]*2*.2)), (float)(xCenter-boundingBox[2]), (float)(yCenter+(boundingBox[3]))*(hitpoints/maxHp)), (float)(xCenter+boundingBox[2]));
        
    }
    public void tickAttack() {
        if (!globalTimer.timerDone(this.staticHash)) {
            return;
        }
        int ilen = ((Game) scene).getAsteroids().size();
        switch (phase) {
        case 0:
            phase += 1;
            //phase = 6;
            globalTimer.addTimer(this.staticHash, 3000);
            break;
        case 1:
            for (int i=0; i<10; i++) {
                ((Game) scene).getAsteroids().add(new BasicAsteroid((width/10)*i+(width/20), (int)(height*.1), 50, 50, new int[] {255,255,255}, 5));
                ((Game) scene).getAsteroids().get(ilen+i).accelerate(1);
            }
            ilen = ((Game) scene).getAsteroids().size();
            phase += 1;
            globalTimer.addTimer(this.staticHash, 4000);
            break;
        case 2:
            for (int i=0; i<3; i++) {
                ((Game) scene).getAsteroids().add(new HomingAsteroid((width/3)*i+(width/6), (int)(height*.1), 50, 50, new int[] {255,255,255}, 5, 1, ((Game)scene).getShip()));
                ((Game) scene).getAsteroids().get(ilen+i).accelerate(1);
                ((Game) scene).getAsteroids().get(ilen+i).turn(45);
            }
            phase += 1;
            globalTimer.addTimer(this.staticHash, 4000);
            break;
        case 3:
            int anum = 10;
            for (int i=0; i<anum; i++) {
                ((Game) scene).getAsteroids().add(new BasicAsteroid((int)(xCenter+Math.cos(PI/anum*(i+1))*50), (int)(yCenter+Math.sin(PI/anum*(i+1))*50), 50, 50, new int[] {255,255,255}, 5));
                ((Game) scene).getAsteroids().get(ilen+i).turn(180*((double)i/anum)-90);
                ((Game) scene).getAsteroids().get(ilen+i).accelerate(1);
            }
            phase +=1;
            globalTimer.addTimer(this.staticHash, 4000);
            break;
        case 4:
            final int num4 = 30;
            /*for (int i=0; i<bnum; i++) {
              ((Game) scene).getAsteroids().add(new BasicAsteroid((int)(xCenter+Math.cos(PI*4/bnum*(i+1))*5*i), (int)(yCenter+Math.sin(PI*4/bnum*(i+1))*5*i), 50, 50, new int[]{255,255,255}, 5));
              ((Game) scene).getAsteroids().get(ilen+i).turn(360*2*((double)i/bnum)-90);
              ((Game) scene).getAsteroids().get(ilen+i).accelerate(1);
            }*/
            //use ilen because previous asteroids might have been destroyed
            ((Game) scene).getAsteroids().add(new BasicAsteroid((int)(xCenter+Math.cos(PI*4/num4*(subphase+1))*5*subphase), (int)(yCenter+Math.sin(PI*4/num4*(subphase+1))*5*subphase), 50, 50, new int[] {255,255,255}, 5));
            ((Game) scene).getAsteroids().get(ilen).turn(360*2*((double)subphase/num4)-90);
            ((Game) scene).getAsteroids().get(ilen).accelerate(1);
            subphase++;
            if (subphase == num4) {
                subphase = 0;
                phase +=1;
                globalTimer.addTimer(this.staticHash, 4000);
            }
            break;
        case 5:
            int num5 = 18;
            for (int i=0; i<num5; i++) {
                ((Game) scene).getAsteroids().add(new BasicAsteroid((int)(xCenter+Math.cos(PI*2/num5*(i+1))*50), (int)(yCenter+Math.sin(PI*2/num5*(i+1))*50), 50, 50, new int[] {255,255,255}, 5));
                ((Game) scene).getAsteroids().get(ilen+i).turn(360*((double)i/num5)-90);
                ((Game) scene).getAsteroids().get(ilen+i).accelerate(1);
            }
            for (int i=0; i<num5; i++) {
                ((Game) scene).getAsteroids().add(new BasicAsteroid((int)(xCenter+Math.cos(PI*2/num5*(i+1))*50), (int)(yCenter+Math.sin(PI*2/num5*(i+1))*50), 50, 50, new int[] {255,255,255}, 5));
                ((Game) scene).getAsteroids().get(ilen+num5+i).turn(360*((double)i/num5)-45);
                ((Game) scene).getAsteroids().get(ilen+num5+i).accelerate(1.5);
            }
            phase +=1;
            globalTimer.addTimer(this.staticHash, 4000);
            break;
        case 6:
            int num6 = 30;
            for (int i=0; i<num6; i++) {
                ((Game) scene).getAsteroids().add(new BasicAsteroid((int)(xCenter+Math.cos(PI/2/num6*(i+1))*50), (int)(yCenter+Math.sin(PI/2/num6*(i+1))*50), 50, 50, new int[] {255,255,255}, 5));
                ((Game) scene).getAsteroids().get(ilen+i).turn(90*((double)i/num6));
                ((Game) scene).getAsteroids().get(ilen+i).accelerate(1);
            }
            phase +=1;
            globalTimer.addTimer(this.staticHash, 4000);
            break;
        default:
            phase = 1;
            break;
        }
    }
}
