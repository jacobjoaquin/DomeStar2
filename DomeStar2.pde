import java.io.*;

import processing.video.*;
import netP5.*;
import oscP5.*;
import controlP5.*;

OscP5 osc;
MapEntry[] map;
Transmitter transmitter;
float pan = 0.5;

boolean shouldChangeRoutine = false;
int colorOffset = 0;
int[] gammaTable = new int[256];

// Viewports
Viewport viewportLeft;
Viewport viewportRight;
ViewportList viewportList = new ViewportList();
ViewportMixer viewportMixer;

// GUI
ControlP5 cp5;
Slider sliderPan;
Slider2D panAndScanLeftSlider;
Slider2D panAndScanRightSlider;
// Slider2D viewportRightPanAndScan;

// Effects
PanAndScan panAndScanLeft;
// float panAndScanLeftX = 0.0;
// float panAndScanLeftY = 0.0;
PanAndScan panAndScanRight;
// float panAndScanLeftX = 0.0;
// float panAndScanLeftY = 0.0;

RoutineFactory[] routines = new RoutineFactory[] {
  new PerlinFactory(),
  new RectFactory(),
  new KaleFactory(),
  new StarFactory(),
  // new MovieFactory()
};

public void setup() {
  size(600, 620, P2D);
  frameRate(60);
  initGammaTable();

  // GUI
  cp5 = new ControlP5(this);
  sliderPan = cp5.addSlider("pan")
  .setPosition(150,300)
  .setRange(0, 1.0)
  .setSize(300, 20)
  .setColorForeground(color(255, 0, 128))
  .setColorBackground(color(128, 0, 64))
  .setColorActive(color(255, 48, 192));

  panAndScanLeftSlider = cp5.addSlider2D("Pan and Scan Left")
  .setPosition(0, 320)
  .setSize(150, 150)
  .setArrayValue(new float[] {0.5, 0.5})
  .setColorForeground(color(255, 0, 128))
  .setColorBackground(color(128, 0, 64))
  .setColorActive(color(255, 48, 192));

  panAndScanRightSlider = cp5.addSlider2D("Pan and Scan Right")
  .setPosition(450, 320)
  .setSize(150, 150)
  .setArrayValue(new float[] {0.5, 0.5})
  .setColorForeground(color(255, 0, 128))
  .setColorBackground(color(128, 0, 64))
  .setColorActive(color(255, 48, 192));

  // Create viewports
  viewportLeft = new Viewport(0, 0, 300, 300);
  viewportRight = new Viewport(300, 0, 300, 300);
  viewportMixer = new ViewportMixer(150, 320, 300, 300);
  viewportLeft.setRoutine(pickRoutine());
  viewportRight.setRoutine(pickRoutine());
  viewportList.add(viewportLeft);
  viewportList.add(viewportRight);
  viewportMixer.setViewports(viewportLeft, viewportRight);

  // Effects
  panAndScanLeft = new PanAndScan();
  viewportLeft.addEffect(panAndScanLeft);
  panAndScanRight = new PanAndScan();
  viewportRight.addEffect(panAndScanRight);

  Mapper mapper = new Mapper();
  map = mapper.build();

  transmitter = new Transmitter(this);
  // osc = new OscP5(this, 9000);
}

void resetCrossFade() {
  pan = 0.5;
}

void requestChangeRoutine() {
  shouldChangeRoutine = true;
}

// Do not call directly, instead set shouldChangeRoutine
void changeRoutine() {
  shouldChangeRoutine = false;

  // Update the routine faded away, or
  // randomly update one of either the left or right.
  if (pan < 0.25) {
    viewportLeft.setRoutine(pickRoutine());
  } else if (pan > 0.75) {
    viewportRight.setRoutine(pickRoutine());
  } else if (random(2) > 1.0) {
    viewportLeft.setRoutine(pickRoutine());
  } else {
    viewportRight.setRoutine(pickRoutine());
  }
}

void mousePressed() {
  requestChangeRoutine();
}

void mouseMoved() {
  // Control microviews here
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
    // Control microviews here
  }
  else if (pattern.endsWith("/button/Plus")) {
    // panOfs = -2 * message.get(0).floatValue();
  }
  else if (pattern.endsWith("/button/Minus")) {
    // panOfs = 2 * message.get(0).floatValue();
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
  viewportMixer.setPan(pan);
  float[] panAndScanArrayLeft = panAndScanLeftSlider.getArrayValue();
  panAndScanLeft.xMod = panAndScanArrayLeft[0] / 100.0;
  panAndScanLeft.yMod = panAndScanArrayLeft[1] / 100.0;
  float[] panAndScanArrayRight = panAndScanRightSlider.getArrayValue();
  panAndScanRight.xMod = panAndScanArrayRight[0] / 100.0;
  panAndScanRight.yMod = panAndScanArrayRight[1] / 100.0;

  // Update routines
  if (shouldChangeRoutine) {
    changeRoutine();
  }

  // Update and display viewports
  viewportList.update();
  viewportList.display();
  viewportMixer.update();
  viewportMixer.display();

  // Output canvas
  // PGraphics output = viewportMixer.getOutput();
  // image(output, width - Config.STRIPS - 20, 320);
  // transmitter.sendData(output);
}
