Routine leftRoutine;
Routine rightRoutine;
PGraphics mix;
MapEntry[] map;
Transmitter transmitter;
float fader = 127;

int xofs,yofs,xfade;
public void setup() {
  size(1024, 1024, P3D);
  frameRate(60);
  colorMode(HSB);
  
  leftRoutine = new RoutinePermutatingRect();
  leftRoutine.beginDraw();
  leftRoutine.setup();
  leftRoutine.endDraw();

  rightRoutine = new RoutinePermutatingRect();
  rightRoutine.beginDraw();
  rightRoutine.setup();
  rightRoutine.endDraw();
  
  mix = createGraphics(360, 360, P3D);
  
  Mapper mapper = new Mapper();
  map = mapper.build();
  
  transmitter = new Transmitter(this);
}

// Scroll wheel sets cross fader.  TODO make WiiMote and auto.
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  fader = max(0, min(255, fader + e));
}

public void draw() {
  background(100);
  
  // Draw the left routine
  leftRoutine.beginDraw();
  leftRoutine.draw();
  leftRoutine.endDraw();
  
  // Draw the right routine
  rightRoutine.beginDraw();
  rightRoutine.draw();
  rightRoutine.endDraw();

  // Figure out center offsets
  xofs = (mouseX - width/2) / (width / 90);
  yofs = (mouseY - height/2) / (height / 90);
  
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
  mix.tint(127, 255, 255, fader);
  leftRoutine.imageCenter(mix, 180+xofs, 180+yofs);
  mix.tint(127, 255, 255, 255-fader);
  rightRoutine.imageCenter(mix, 180-xofs, 180-yofs);
  mix.endDraw();  
  image(mix, width/2-180, 3*height/4-180);
 
  // Draw the fader bar
  stroke(0, 0, 255);
  strokeWeight(10);
  xfade = width/2 - (fader-127)*2;
  line(xfade, height/2, xfade, height/2 + 50);
  
  // Send the mix to the dome
  transmitter.sendData(mix, map); 
}