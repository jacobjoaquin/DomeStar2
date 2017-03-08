class ViewportList extends ArrayList<Viewport> {
  void update() {
    for (Viewport vp : this) {
      vp.update();
    }
  }

  void display() {
    for (Viewport vp : this) {
      vp.display();
    }
  }
}

class Viewport {
  int x;
  int y;
  int w;
  int h;
  protected PGraphics pg;
  Routine routine;

  Viewport(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void update() {
    routine.beginDraw();
    routine.draw();
    routine.endDraw();
  }

  void display() {
    pushStyle();
    imageMode(CORNER);
    image(pg, x, y, w, h);
    popStyle();
  }

  void setRoutine(Routine routine) {
    this.routine = routine;
    pg = routine.getPG();
  }

  PGraphics getPG() {
    return pg;
  }
}

class ViewportMixer {
  int x;
  int y;
  int w;
  int h;
  Viewport viewport0;
  Viewport viewport1;
  int blendMode = ADD;
  private float pan = 0.5;
  private PGraphics pg;
  private PGraphics output;

  ViewportMixer(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    pg = createGraphics(360, 360, P2D);
    output = createGraphics(Config.STRIPS, Config.LEDS, P2D);
  }

  void setPan(float value) {
    pan = value;
  }

  PGraphics getPG() {
    return pg;
  }

  void setViewports(Viewport viewport0, Viewport viewport1) {
    this.viewport0 = viewport0;
    this.viewport1 = viewport1;
  }

  void update() {
    pg.beginDraw();
    pg.pushStyle();
    pg.background(0);
    pg.blendMode(blendMode);
    pg.tint(255, 256 * (1.0 - pan));
    pg.image(viewport0.getPG(), 0, 0, pg.width, pg.height);
    pg.tint(255, 256 * pan);
    pg.image(viewport1.getPG(), 0, 0, pg.width, pg.height);
    pg.popStyle();
    pg.endDraw();

    createOutput();
  }

  void display() {
    pushStyle();
    imageMode(CORNER);
    image(pg, x, y, w, h);
    popStyle();
  }

  PGraphics getOutput() {
    return output;
  }

  private void createOutput() {
    int w = pg.width;
    pg.loadPixels();
    output.beginDraw();
    output.loadPixels();

    for (MapEntry entry : map) {
      color c = pg.pixels[entry.x + entry.y * w];
      output.pixels[entry.strip + entry.led * Config.STRIPS] = c;
    }

    output.updatePixels();
    output.endDraw();
  }
}
