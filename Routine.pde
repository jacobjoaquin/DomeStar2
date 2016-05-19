public abstract class Routine {
  PGraphics pg = null;
  
  public Routine() {
    this.pg = createGraphics(450, 450, P3D);
  }

  public abstract void setup();
  
  public void beginDraw() {
    pg.beginDraw();
  }
  
  public abstract void draw();
  
  public void endDraw() {
    pg.endDraw();
  }

  public void imageCenter(int x, int y) {
    image(pg, x - pg.width/2, y - pg.width/2);
  }
  
  public void imageCenter(PGraphics tpg, int x, int y) {
    tpg.image(pg, x - pg.width/2, y - pg.width/2);
  }
  
  public int width() { return pg.width; }
  public int height() { return pg.height; }
}