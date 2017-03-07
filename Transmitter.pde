import hypermedia.net.*;

public class Transmitter {
  private UDP udp;
  private byte buffer[];

  public Transmitter(PApplet parent) {
    this.udp = new UDP(parent);
    buffer = new byte[Config.STRIPS * Config.LEDS * 3 + 1];
    buffer[0] = 1;
  }

  public void sendData(PGraphics pg, MapEntry[] map) {
    int w = pg.width;
    pg.loadPixels();

    for (MapEntry entry : map) {
      color c = pg.pixels[entry.y * w + entry.x];
      int r = (c >> 16) & 0xff;
      int g = (c >> 8) & 0xff;
      int b = c & 0xff;

      if (Config.ENABLE_GAMMA) {
        r = gammaTable[r];
        g = gammaTable[g];
        b = gammaTable[b];
      }

      int idx = (entry.led * Config.STRIPS + entry.strip) * 3 + 1;
      buffer[idx] = (byte)r;

      if (Config.SWAP_LOOKUP[entry.strip]) {
        buffer[idx + 2] = (byte)g;
        buffer[idx + 1] = (byte)b;
      } else {
        buffer[idx + 1] = (byte)g;
        buffer[idx + 2] = (byte)b;
      }
    }

    udp.send(buffer, Config.HOST, Config.PORT);
  }
}
