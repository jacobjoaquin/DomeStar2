import java.io.*;

import processing.video.*;
import netP5.*;
import oscP5.*;


OscP5 osc;
Routine leftRoutine;
Routine rightRoutine;
PGraphics mix;
PGraphics output;
MapEntry[] map;
Transmitter transmitter;
float fader = 127;
float faderOfs = 0;

int xofs,yofs;
float xfade;
boolean shouldChangeRoutine = false;
int colorOffset = 0;

int[] gammaTable = new int[256];

RoutineFactory[] routines = new RoutineFactory[] {
  new PerlinFactory(),
  new RectFactory(),
  // new KaleFactory(),
  new StarFactory(),
  // new MovieFactory()
};

public void setup() {
  size(1024, 1024, P2D);
  frameRate(60);
  // noSmooth();
  imageMode(CENTER);
  initGammaTable();

  leftRoutine = pickRoutine();
  rightRoutine = pickRoutine();

  mix = createGraphics(360, 360, P2D);
  output = createGraphics(Config.LEDS, Config.STRIPS, P2D);

  output.beginDraw();
  output.background(0);
  output.ellipse(output.width / 2.0, output.height / 2.0, 10, 10);
  output.endDraw();

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
    leftRoutine = pickRoutine();
  } else if (fader > 200) {
    rightRoutine = pickRoutine();
  } else if (random(2) > 1.0) {
    leftRoutine = pickRoutine();
  } else {
    rightRoutine = pickRoutine();
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

  addCrossFade(faderOfs);

  // Check here for changing routines to ensure we're in the
  // drawing thread.  Events can come from other threads.
  if (shouldChangeRoutine)
    changeRoutine();

  // Draw the left routine
  leftRoutine.beginDraw();
  leftRoutine.draw();
  leftRoutine.endDraw();

  // Draw the right routine
  rightRoutine.beginDraw();
  rightRoutine.draw();
  rightRoutine.endDraw();

  // Blit the left and right routines to screen with offsets
  leftRoutine.imageCenter(width/4+xofs, height/4+yofs);
  rightRoutine.imageCenter(3*width/4-xofs, height/4-yofs);

  // Draw the clipping box
  noFill();
  stroke(100, 255, 255);
  strokeWeight(1);
  rect(width/4-180-1, height/4-180-1, 362, 362);
  rect(3*width/4-180-1, height/4-180-1, 362, 362);

  // Blit the left and right to the mix with tint and fade
  mix.beginDraw();
  mix.background(0);
  mix.blendMode(ADD);
  mix.tint(255, fader);
  leftRoutine.imageCenter(mix, 180+xofs, 180+yofs);
  mix.tint(255, 255-fader);
  rightRoutine.imageCenter(mix, 180-xofs, 180-yofs);
  mix.endDraw();
  pushStyle();
  imageMode(CENTER);
  image(mix, width/2.0, 3*height/4);
  popStyle();

  // Draw the fader bar
  stroke(0);
  line(width/2-255,height/2+25,width/2+255,height/2+25);
  stroke(0, 0, 255);
  strokeWeight(10);
  xfade = width/2 - (fader-127)*2;
  line(xfade, height/2, xfade, height/2 + 50);

  mixToOutput();

  // Output canvas
  imageMode(CORNER);
  image(output, 50, 700);

  // Send the mix to the dome
  transmitter.sendData(mix, map);
  // transmitter.sendData(output);
}

void mixToOutput() {
  int w = mix.width;
  mix.loadPixels();
  output.loadPixels();

  for (MapEntry entry : map) {
    color c = mix.pixels[entry.y * w + entry.x];
    output.pixels[entry.strip * Config.LEDS + entry.led] = c;
  }

  output.updatePixels();
}
