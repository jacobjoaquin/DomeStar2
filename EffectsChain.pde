class EffectsChain {
  ArrayList<Effect> list = new ArrayList<Effect>();
  protected Viewport viewport;
  PGraphics pg;

  EffectsChain(Viewport viewport) {
    this.viewport = viewport;
    pg = viewport.getPG();
  }

  void add(Effect effect) {
    effect.setParent(this);
    list.add(effect);
  }

  Effect get(int index) {
    return list.get(index);
  }

  PGraphics getPG() {
    return pg;
  }

  Viewport getViewport() {
    return viewport;
  }

  void update() {
    pg = viewport.getPG();
    for (Effect effect : list) {
      effect.update();
      pg = effect.getPG();
    }
  }

  void displayOverlay() {
    for (Effect effect : list) {
      effect.displayOverlay();
    }
  }
}

abstract class Effect {
  protected EffectsChain parent;
  protected Viewport viewport;
  protected PGraphics pgViewport;
  protected PGraphics pg;

  void update() {
  }

  void displayOverlay() {
  }

  PGraphics getPG() {
    return pg;
  }

  final void setParent(EffectsChain parent) {
    println("Effect.setParent()");
    this.parent = parent;
    viewport = parent.getViewport();
    pgViewport = viewport.getPG();
    pg = createGraphics(pgViewport.width, pgViewport.height, P2D);
  }
}
