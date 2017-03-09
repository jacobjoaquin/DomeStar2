class PanAndScan extends Effect{
  float x;
  float y;
  float s;
  float xMod = 0.0;
  float yMod = 0.0;
  float sizeMod = 1.0;
  float ratio = 1.0;

  PanAndScan() {
  }

  PanAndScan(float ratio) {
    this.ratio = ratio;
  }

  void init() {
    s = pg.width * ratio;
  }

  void setSizeMod(float value) {
    this.sizeMod = value;
  }

  void update() {
    ratio = sizeMod;
    s = pg.width * ratio;
    x = xMod * (pg.width - s);
    y = yMod * (pg.height - s);

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
