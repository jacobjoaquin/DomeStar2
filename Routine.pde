public abstract class Routine {
  protected PGraphics pg = null;
  protected final int drawWidth = 450;
  protected final int drawHeight = 450;

  public Routine(int w, int h) {
    this.pg = createGraphics(w, h, P2D);
  }

  public Routine(int w, int h, String renderer) {
    this.pg = createGraphics(w, h, renderer);
  }

  public abstract void setup();
  public abstract void draw();

  public final void beginDraw() {
    pg.beginDraw();
  }

  public final void endDraw() {
    pg.endDraw();
  }

  public int width() { return pg.width; }
  public int height() { return pg.height; }

  public PGraphics getPG() {
    return pg;
  }
}

public interface RoutineFactory {
  Routine create(PApplet parent);
}
