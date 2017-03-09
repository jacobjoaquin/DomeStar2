class PanAndScan extends Effect{
  float x;
  float y;
  float s;

  PanAndScan() {
  }

  void update() {
    s = pg.width / 2.0;
    x = map(mouseX, 0, width, 0, pg.width - s);
    y = map(mouseY, 0, height, 0, pg.height - s);

    pg.beginDraw();
    pg.copy(pgViewport, (int)x, (int)y, (int)s, (int)s, 0, 0, pg.width, pg.height);
    pg.endDraw();
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
