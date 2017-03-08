import java.io.*;

import processing.video.*;
import netP5.*;
import oscP5.*;


OscP5 osc;
MapEntry[] map;
Transmitter transmitter;
float fader = 127;
float faderOfs = 0;

int xofs,yofs;
float xfade;
boolean shouldChangeRoutine = false;
int colorOffset = 0;

int[] gammaTable = new int[256];

ViewportList viewportList = new ViewportList();
ViewportMixer viewportMixer;

RoutineFactory[] routines = new RoutineFactory[] {
  new PerlinFactory(),
  new RectFactory(),
  new KaleFactory(),
  new StarFactory(),
  new MovieFactory()
};

public void setup() {
  size(400, 400, P2D);
  frameRate(60);
  initGammaTable();

  // Create viewports
  Viewport vp0 = new Viewport(0, 0, 200, 200);            // Left Viewport
  Viewport vp1 = new Viewport(200, 0, 200, 200);          // Right Viewport
  viewportMixer = new ViewportMixer(100, 200, 200, 200);  // Mixer
  vp0.setRoutine(pickRoutine());
  vp1.setRoutine(pickRoutine());
  viewportList.add(vp0);
  viewportList.add(vp1);
  viewportMixer.setViewports(vp0, vp1);

  Mapper mapper = new Mapper();
  map = mapper.build();

  transmitter = new Transmitter(this);
  // osc = new OscP5(this, 9000);
}

void addCrossFade(float e) {
  fader = max(0, min(255, fader + e));
}

void resetCrossFade() {
  fader = 127;
}

void setCenterOffset(int x, int y, int maxX, int maxY) {
  xofs = (x - maxX/2) / (maxX / 90);
  yofs = (y - maxY/2) / (maxY / 90);
}

void requestChangeRoutine() {
  shouldChangeRoutine = true;
}

// Do not call directly, instead set shouldChangeRoutine
void changeRoutine() {
  shouldChangeRoutine = false;

  // Update the routine faded away, or
  // randomly update one of either the left or right.
  if (fader < 50) {
    // leftRoutine = pickRoutine();
  } else if (fader > 200) {
    // rightRoutine = pickRoutine();
  } else if (random(2) > 1.0) {
    // leftRoutine = pickRoutine();
  } else {
    // rightRoutine = pickRoutine();
  }
}

void mouseWheel(MouseEvent event) {
  addCrossFade(event.getCount());
}

void mousePressed() {
  requestChangeRoutine();
}

void mouseMoved() {
  setCenterOffset(mouseX, mouseY, width, height);
}

void keyPressed() {
  rotateColors(1);

}

void oscEvent(OscMessage message) {
  String pattern = message.addrPattern();
  //message.print();

  if (!pattern.startsWith("/wii/"))
    return;

  if (pattern.endsWith("/button/A") && message.get(0).floatValue() == 0) {
    requestChangeRoutine();
  }
  else if (pattern.endsWith("/motion/angles")) {
    setCenterOffset(
      int(message.get(2).floatValue()*255),
      int(message.get(0).floatValue()*255),
      255,255
    );
  }
  else if (pattern.endsWith("/button/Plus")) {
    faderOfs = -2 * message.get(0).floatValue();
  }
  else if (pattern.endsWith("/button/Minus")) {
    faderOfs = 2 * message.get(0).floatValue();
  }
  else if (pattern.endsWith("/button/Home")) {
    resetCrossFade();
  }
  else if (pattern.endsWith("/button/Up")) {
    rotateColors(1);
  }
  else if (pattern.endsWith("/button/Down")) {
    rotateColors(-1);
  }
}

Routine pickRoutine() {
  int idx = int(random(routines.length));
  RoutineFactory factory = routines[idx];

  Routine instance = factory.create(this);
  instance.beginDraw();
  instance.setup();
  instance.endDraw();
  return instance;
}

public void rotateColors(int ofs) {
  int len = Config.PALETTE.length;
  colorOffset += ofs;

  if (colorOffset >= len)
    colorOffset -= len;
  else if (colorOffset < 0)
    colorOffset += len;
}

public color getColor() {
  return getColor(0);
}

public color getColor(int idx) {
  idx += colorOffset;
  int len = Config.PALETTE.length;

  while(idx>=len) idx-=len;
  while(idx<0) idx+=len;

  return Config.PALETTE[idx];
}

public void draw() {
  background(100);
  // Update modulation sources
  viewportMixer.setPan(map(mouseX, 0, width, 0, 1));

  // Update and display viewports
  viewportList.update();
  viewportList.display();
  viewportMixer.update();
  viewportMixer.display();

  // Output canvas
  PGraphics output = viewportMixer.getOutput();
  // imageMode(CORNER);
  image(output, 0, 200);
  transmitter.sendData(output);
}
