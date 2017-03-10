import java.io.*;

import processing.video.*;
import netP5.*;
import oscP5.*;
import controlP5.*;

OscP5 osc;
MapEntry[] map;
Transmitter transmitter;

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
Slider panAndScanLeftSizeSlider;
Slider panAndScanRightSizeSlider;
float panAndScanLeftSize = 1.0;
float panAndScanRightSize = 1.0;

// Effects
float pan = 0.5;
PanAndScan panAndScanLeft;
PanAndScan panAndScanRight;

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
  initControls();

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

public void draw() {
  background(100);

  // Update modulations
  updateModulations();

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
  PGraphics output = viewportMixer.getOutput();
  // image(output, width - Config.STRIPS - 20, 320);
  transmitter.sendData(output);
}
