/*
PanAndScan

Reimplementation of the original pan and scan to utilize the
Effect and EffectChain classes.
*/
class PanAndScan extends Effect{
  float x;
  float y;
  float s;
  float xMod = 0.0;    // Modulation for x. Range [0.0, 1.0]
  float yMod = 0.0;    // Modulation for y. Range [0.0, 1.0]
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

  // Modulates the size of the pan and scan window
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

  // Draws a rect over the viewport to indicate the part of the image is being
  // drawn.
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
