public abstract class Routine {
  protected PGraphics pg = null;
  
  public Routine(int w, int h) {
    this.pg = createGraphics(w, h, P3D);
  }

  public abstract void setup();
  public abstract void draw();
  
  public final void beginDraw() {
    pg.beginDraw();
  }
    
  public final void endDraw() {
    pg.endDraw();
  }

  public void imageCenter(int x, int y) {
    image(pg, (x - 450/2), y - 450/2, 450, 450);
  }
  
  public void imageCenter(PGraphics tpg, int x, int y) {
    tpg.image(pg, x - 450/2, y - 450/2, 450, 450);
  }
  
  public int width() { return pg.width; }
  public int height() { return pg.height; }
}

public interface RoutineFactory {
  Routine create(PApplet parent);
}