abstract class Widget {
    //basic drawable box with a clicked method and some template variables
    protected int[] boundingBox;
    protected int xCenter;
    protected int yCenter;
    protected int w;
    protected int h;
    protected boolean isClicked(int x, int y) {
        return boundingBox[0] <= x && x <= boundingBox[2] && boundingBox[1] <= y && y <= boundingBox[3];
    }
    public abstract void render();
}

class Button extends Widget {
    //a box with text
    protected String text_;
    protected int[] textColor;
    protected int[] hoverColor;
    public Button(int xCenter, int yCenter, int h, String text_, int[] textColor) {
        textSize(h*.75);
        int w = (int) (textWidth(text_)*1.2);
        boundingBox = new int[] {xCenter-(w/2), yCenter-(h/2), xCenter+w/2, yCenter+h/2};
        this.xCenter = xCenter;
        this.yCenter = yCenter;
        this.text_ = text_;
        this.w = w;
        this.h = h;
        this.textColor = textColor;
        this.hoverColor = textColor;
    }
    public Button(int xCenter, int yCenter, int h, String text_, int[] textColor, int[] hoverColor) {
        this(xCenter, yCenter, h, text_, textColor);
        this.hoverColor = hoverColor;
    }
    public void render() {
        rect(boundingBox[0], boundingBox[1], w, h);
        if (isClicked(mouseX, mouseY)) {
            fill(hoverColor[0], hoverColor[1], hoverColor[2]);
        } else {
            fill(textColor[0], textColor[1], textColor[2]);
        }
        textSize(h*.75);
        textAlign(CENTER);
        text(this.text_, xCenter, yCenter+(h/4));
    }
}

class Popup extends Widget {
    protected int[] textColor;
    protected String text_;
    protected double delay;
    protected double fadeout;
    protected String staticHash;
    protected int state;
    public Popup(int xCenter, int yCenter, int h, String text_, int[] textColor, double delay, double fadeout) {
        textSize(h*.75);
        int w = (int) (textWidth(text_)*1.2);
        boundingBox = new int[] {xCenter-(w/2), yCenter-(h/2), xCenter+w/2, yCenter+h/2};
        this.xCenter = xCenter;
        this.yCenter = yCenter;
        this.text_ = text_;
        this.w = w;
        this.h = h;
        this.textColor = textColor;
        this.delay = delay;
        this.fadeout = fadeout;
        this.staticHash = String.valueOf(this.hashCode());
        this.state = 0;
        globalTimer.addTimer(staticHash, delay);
    }
    public void render() {
        if (!globalTimer.timerDone(staticHash) && state == 0) {
            fill(textColor[0], textColor[1], textColor[2]);
            textSize(h*.75);
            textAlign(CENTER);
            text(this.text_, xCenter, yCenter+(h/4));
        }
        else if (globalTimer.timerDone(staticHash) && state == 0) {
            fill(textColor[0], textColor[1], textColor[2]);
            textSize(h*.75);
            textAlign(CENTER);
            text(this.text_, xCenter, yCenter+(h/4));
            globalTimer.addTimer(staticHash, fadeout);
            state = 1;
        }
        else if (!globalTimer.timerDone(staticHash) && state == 1) {
            fill(textColor[0], textColor[1], textColor[2], (float)(255*(globalTimer.getDiff(staticHash)/fadeout)));
            textSize(h*.75);
            textAlign(CENTER);
            text(this.text_, xCenter, yCenter+(h/4));
        }
        else if (globalTimer.timerDone(staticHash) && state == 1) {
            //System.out.println("w");
            state = 2;
        }
    }
}
