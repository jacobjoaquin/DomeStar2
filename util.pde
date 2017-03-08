// Initializes the gamma table
void initGammaTable() {
  for (int i = 0; i < 256; i++) {
    gammaTable[i] = (int)(Math.pow((float) i / 256.0, Config.GAMMA_VALUE) * 256);
  }
}
