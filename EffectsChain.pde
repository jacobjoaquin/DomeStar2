/*
Effects Chain

A list of effects queued in series. This is designed to be the child
of a viewport.
*/
class EffectsChain {
  ArrayList<Effect> list = new ArrayList<Effect>();
  protected Viewport viewport;
  PGraphics pg;

  EffectsChain(Viewport viewport) {
    this.viewport = viewport;
    pg = viewport.getPG();
  }

  // This re-connects the effects in the chain to a routine.
  // This is called by viewport when a new routined is seleccted.
  void updateRoutine() {
    // Updates all the PGs down the chain
    for (Effect effect : list) {
      effect.setParent(this);
    }
  }

  // Add an effect to the end of the chain
  void add(Effect effect) {
    effect.setParent(this);
    list.add(effect);
  }

  // Get an effect by index from the chain.
  Effect get(int index) {
    return list.get(index);
  }

  // Returns the active drawing canvas
  PGraphics getPG() {
    return pg;
  }

  // Returns the partent viewport
  Viewport getViewport() {
    return viewport;
  }

  // Run all the effects
  // TODO: Only tested with a single effect
  void update() {
    pg = viewport.getPG();
    for (Effect effect : list) {
      effect.update();
      pg = effect.getPG();
    }
  }

  // Displays the overlays on top of the viewport.
  // Any changes here isn't introduced in the output.
  void displayOverlay() {
    for (Effect effect : list) {
      effect.displayOverlay();
    }
  }
}

/*
Effect

An Effect is a routine post-processor.

An effect is designed to be the child of an EffectsChain and a
grandchild of a viewport.
*/
abstract class Effect {
  protected EffectsChain parent;
  protected Viewport viewport;
  protected PGraphics pgViewport;
  protected PGraphics pg;

  // Processes a canvas
  void update() {
  }

  // (optional) Allows drawing on top of the viewport without introducing
  // changes in the final output of the viewport of EffectsChain
  // TODO: Utilize clip() and noClip() so overlays don't bleed outside
  // of the viewport area.
  void displayOverlay() {
  }

  // Any code that needs to be initialized or re-initialed when a routine
  // is added or changed in the viewport
  void init() {
  }

  // Returns this effect's canvas
  PGraphics getPG() {
    return pg;
  }

  // Connects all the things
  final void setParent(EffectsChain parent) {
    this.parent = parent;
    viewport = parent.getViewport();
    pgViewport = viewport.getPG();
    pg = createGraphics(pgViewport.width, pgViewport.height, P2D);
    init();
  }
}
