// Initializes the gamma table
void initGammaTable() {
  for (int i = 0; i < 256; i++) {
    gammaTable[i] = (int)(Math.pow((float) i / 256.0, Config.GAMMA_VALUE) * 256);
  }
}

// Mix canvas to output canvas
void mixToOutput() {
  int w = mix.width;
  mix.loadPixels();
  output.beginDraw();
  output.loadPixels();

  for (MapEntry entry : map) {
    color c = mix.pixels[entry.x + entry.y * w];
    output.pixels[entry.strip + entry.led * Config.STRIPS] = c;
  }

  output.updatePixels();
  output.endDraw();
}
