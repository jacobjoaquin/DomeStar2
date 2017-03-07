import hypermedia.net.*;

public class Transmitter {
  UDP udp;
  byte buffer[];

  public Transmitter(PApplet parent) {
    this.udp = new UDP(parent);

    buffer = new byte[Config.STRIPS * Config.LEDS * 3 + 1];

    for (int i=0; i<buffer.length; i++) {
      buffer[i] = 0;
    }
  }

  public void sendData(PGraphics pg, MapEntry[] map) {
    color c;
    int r;
    int g;
    int b;
    int idx;
    int tmp;

    pg.loadPixels();
    buffer[0] = 1;
    for (MapEntry entry : map) {
      c = pg.pixels[entry.y * pg.width + entry.x];
      r = int(red(c));
      g = int(green(c));
      b = int(blue(c));

      if (Config.ENABLE_GAMMA) {
        r = (int)(Math.pow(r/256.0,Config.GAMMA_VALUE)*256);
        g = (int)(Math.pow(g/256.0,Config.GAMMA_VALUE)*256);
        b = (int)(Math.pow(b/256.0,Config.GAMMA_VALUE)*256);
      }

      if (Config.SWAP_LOOKUP[entry.strip]) {
        tmp = g;
        g = b;
        b = tmp;
      }

      idx = (entry.led * Config.STRIPS + entry.strip) * 3 + 1;
      buffer[idx] = byte(r);
      buffer[idx+1] = byte(g);
      buffer[idx+2] = byte(b);
    }

    udp.send(buffer, Config.HOST, Config.PORT);
  }
}
