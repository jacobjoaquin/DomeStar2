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
  float x;
  float y;
  float w;
  float h;
  protected PGraphics pg;
  Routine routine;

  Viewport(float x, float y, float w, float h) {
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
    image(pg, x, y, w, h);
  }

  void setRoutine(Routine routine) {
    this.routine = routine;
    pg = routine.getPG();
  }
}
