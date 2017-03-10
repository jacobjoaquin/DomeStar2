void initControls() {
// GUI
  CColor guiOrange = new CColor(
    color(128, 96, 0),
    color(128, 64, 0),
    color(255, 128, 0),
    color(255),
    color(255)
  );

  CColor guiMagenta = new CColor(
    color(255, 0, 128),
    color(128, 0, 64),
    color(255, 64, 255),
    color(255),
    color(255));

  cp5 = new ControlP5(this);
  sliderPan = cp5.addSlider("pan")
  .setPosition(150,300)
  .setRange(0, 1.0)
  .setSize(300, 20)
  .setColor(guiMagenta);

  panAndScanLeftSlider = cp5.addSlider2D("Pan and Scan Left")
  .setPosition(0, 320)
  .setSize(150, 150)
  .setArrayValue(new float[] {0.5, 0.5})
  .setColor(guiMagenta);

  panAndScanRightSlider = cp5.addSlider2D("Pan and Scan Right")
  .setPosition(450, 320)
  .setSize(150, 150)
  .setArrayValue(new float[] {0.5, 0.5})
  .setColor(guiMagenta);

  panAndScanLeftSizeSlider = cp5.addSlider("Pan and Scan Size")
  .setPosition(0, 490)
  .setRange(0, 1.0)
  .setSize(150, 20)
  .setLabelVisible(false)
  .setColor(guiMagenta);

  panAndScanRightSizeSlider = cp5.addSlider("Pan and Scan Size2")
  .setPosition(450, 490)
  .setRange(0, 1.0)
  .setSize(150, 20)
  .setLabelVisible(false)
  .setColor(guiMagenta);

  cp5.addButton("newLeft")
  .setValue(0)
  .setPosition(0, 300)
  .setSize(150, 20)
  .setColor(guiOrange);

  cp5.addButton("newRight")
  .setValue(0)
  .setPosition(450, 300)
  .setSize(150, 20)
  .setColor(guiOrange);
}
