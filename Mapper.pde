
class MapEntry {
  int x;
  int y;
  int led;
  int strip;
    
  public MapEntry(int x, int y, int led, int strip) {
    this.x = x;
    this.y = y;
    this.led = led;

    if (Config.STRIP_LOOKUP[strip] >= 0)
      this.strip = Config.STRIP_LOOKUP[strip];
    else
      this.strip = strip;
  }
};

class Mapper {        

  public MapEntry[] build() {
    MapEntry[] lookup = new MapEntry[Config.STRIPS * Config.LEDS];

    for (int strip = 0; strip < Config.STRIPS; strip++) {
      for (int led = 0; led < Config.LEDS; led++) {
        float rotation = (float)strip / Config.STRIPS * TWO_PI;
        float magnitude = (Config.MAP_PADDING + 
          (float)led / Config.LEDS * (Config.MAP_WIDTH / 2 - Config.MAP_PADDING));
        
        if (Config.MAP_SWIRL) {
          if (led > 16) {
            rotation += PI/6 * ((float)led / (Config.LEDS - 16));
          }
          else {
            rotation += PI/6;
          }
        }
        
        int x = int(Config.MAP_WIDTH / 2 + sin(rotation) * magnitude);
        int y = int(Config.MAP_HEIGHT / 2 + cos(rotation) * magnitude);
        
        // TODO Do i need to STRIP_LOOKUP here too?
        lookup[led * Config.STRIPS + strip] = new MapEntry(x, y, led, strip);
      }
    }      

    return lookup;
  }  
}