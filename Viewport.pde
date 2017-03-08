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
  PGraphics pg;

  ViewportMixer(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    pg = createGraphics(w, h, P2D);
  }

  void setViewports(Viewport viewport0, Viewport viewport1) {
    this.viewport0 = viewport0;
    this.viewport1 = viewport1;
  }

  void update() {
    pg.beginDraw();
    pg.pushStyle();
    pg.background(0);
    pg.blendMode(ADD);
    pg.image(viewport0.getPG(), 0, 0, w, h);
    pg.image(viewport1.getPG(), 0, 0, w, h);
    pg.popStyle();
    pg.endDraw();
  }

  void display() {
    pushStyle();
    imageMode(CORNER);
    image(pg, x, y, w, h);
    popStyle();
  }
}
