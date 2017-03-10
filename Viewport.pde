/*
ViewportList

Syntatic sugar for easily updating all viewports.
TODO: Not necessary and should be removed.
*/
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

/*
Viewport
  EffectChain

Updates and displays routines and effects.

A viewport updates and displays routines.
It contains an effects chain where users can add effects that
post-process routines. Effects are queued in series.
*/
class Viewport {
  protected int x;                      // x position
  protected int y;                      // y position
  protected int w;                      // display width
  protected int h;                      // display height
  protected PGraphics pg;               // Canvas
  protected Routine routine;            // Routine
  protected EffectsChain effectsChain;  // Effects chain

  Viewport(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    effectsChain = new EffectsChain(this);
  }


  // Add an effect to the effect chain.
  // Effects are processed in the order they are pushed.
  // TODO: Currently only one effect at a time has been tested.
  void addEffect(Effect effect) {
    effectsChain.add(effect);
  }

  // Update the routine and effects chain
  void update() {
    routine.beginDraw();
    routine.draw();
    routine.endDraw();
    effectsChain.update();
  }

  // Display the viewport and effect overlays
  void display() {
    pushStyle();
    imageMode(CORNER);
    image(pg, x, y, w, h);
    popStyle();
    effectsChain.displayOverlay();
  }

  // Set the routine
  void setRoutine(Routine routine) {
    this.routine = routine;
    pg = routine.getPG();
    effectsChain.updateRoutine();
  }

  // Return the primary canvas
  PGraphics getPG() {
    return pg;
  }

  // Return the effects chain canvas
  PGraphics getEffectsPG() {
    return effectsChain.getPG();
  }
}

/*
Viewport Mixer

Mixes two viewports. Includes modulation source for panning.
*/
class ViewportMixer {
  private int x;
  private int y;
  private int w;
  private int h;
  private Viewport viewport0;
  private Viewport viewport1;
  private int blendMode = ADD;
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

  // Set pan amount between the two viewports
  void setPan(float value) {
    // TODO: Use sin() curves for mixing
    pan = value;
  }

  // Return the canvas
  PGraphics getPG() {
    return pg;
  }

  // Set the viewports
  // TODO: Should this be integrated into the constructor?
  void setViewports(Viewport viewport0, Viewport viewport1) {
    this.viewport0 = viewport0;
    this.viewport1 = viewport1;
  }

  // Updates the canvas. Mixing happens here.
  void update() {
    pg.beginDraw();
    pg.pushStyle();
    pg.background(0);
    pg.blendMode(blendMode);
    pg.tint(255, 256 * (1.0 - pan));
    pg.image(viewport0.getEffectsPG(), 0, 0, pg.width, pg.height);
    pg.tint(255, 256 * pan);
    pg.image(viewport1.getEffectsPG(), 0, 0, pg.width, pg.height);
    pg.popStyle();
    pg.endDraw();

    createOutput();  // Create the output for the transmitter
  }

  // Display on screen
  void display() {
    pushStyle();
    imageMode(CORNER);
    image(pg, x, y, w, h);
    popStyle();
  }

  // Get the "line out" for the transmitter
  PGraphics getOutput() {
    return output;
  }

  // Create the transmitter output view
  // TODO: This output should be its own viewport, with gamma correction effect.
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
