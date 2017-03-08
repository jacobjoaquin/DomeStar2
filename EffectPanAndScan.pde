class PanAndScan {
  Viewport viewport;
  PGraphics pg;
  PGraphics pgFx;
  float x;
  float y;
  float s;

  PanAndScan(Viewport parent, PGraphics pg, PGraphics pgFx) {
    this.pg = pg;
    this.pgFx = pgFx;
    viewport = parent;
  }

  void update() {
    s = pg.width / 2.0;
    x = map(mouseX, 0, width, 0, pg.width - s);
    y = map(mouseY, 0, width, 0, pg.height - s);

    pgFx.beginDraw();
    pgFx.copy(pg, (int)x, (int)y, (int)s, (int)s, 0, 0, pg.width, pg.height);
    pgFx.endDraw();
  }

  void displayOverlay() {
    pushMatrix();
    pushStyle();
    translate(viewport.x, viewport.y);
    float rw = (float) viewport.w / (float) pg.width;
    float rh = (float) viewport.h / (float) pg.height;
    noFill();
    stroke(255, 255, 0, 192);
    rect(x * rw, y * rh, s * rw, s * rh);
    popStyle();
    popMatrix();
  }
}
