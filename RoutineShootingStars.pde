
public class StarFactory implements RoutineFactory {
  public Routine create() {
    return new RoutineShootingStars();
  }
}
public class RoutineShootingStars extends Routine {
  
  public RoutineShootingStars() {
    super(450, 450);
  }

  ArrayList stars = new ArrayList();
  ArrayList palettes = new ArrayList();
  float speed = 3, interval = 5;
  long timeLimit = 10 * 1000L;
  long paletteSwitchTime = 0;
  int paletteIndex = 0;
  
  int[] angles = { 60, 75, 90 };
  
  // Disorient colors
  float[][] palette1 = {
    {255, 140, 0}, // orange
    {255, 105, 180}, // bright pink
    {255, 0, 255}, // purple
    {255, 255, 255} // white
  };
  
  // Icy
  float[][] palette2 = {
    {0, 0, 255}, // blue
    {0, 255, 255}, // cyan
    {255, 255, 255} // white
  };
  
  // Primary rainbow colors
  float[][] palette3 = {
    {255, 0, 0}, // red
    {255, 255, 0}, // yellow
    {0, 255, 0}, // green
    {0, 0, 255}, // blue
    {0, 255, 255}, // cyan
    {255, 0, 255} // purple
  };
  
  // Green colors
  float[][] palette4 = {
    {0, 255, 0}, // green
    {0, 128, 0}, // dark green
    {212, 175, 55}, // gold
    {160, 255, 170} // mint
  };
  
  public void setup() {
    pg.background(0);
    pg.strokeWeight(3);
//    pg.translate(width / 2, height / 2);
    palettes.add(palette1);
    palettes.add(palette2);
    palettes.add(palette3);
    palettes.add(palette4);
    paletteSwitchTime = System.currentTimeMillis();
  }
  
  public void draw() {
    //pg.background(0);
    pg.translate(pg.width/2, pg.height/2);
    if ((frameCount % interval) == 0 && stars.size() < 360) {
      for (int i = 0; i < 360; i += 60) {
        stars.add(new Star(pg, (frameCount + i), random(250, 450)));
      }
    }
    for (int i = 0; i < stars.size(); i++) {
      Star s = (Star)stars.get(i);
      s.draw();
      s.move();
    }
    long timeDelta = System.currentTimeMillis() - paletteSwitchTime;
    if (timeDelta >= timeLimit) {
      paletteIndex++;
      if (paletteIndex % palettes.size() == 0)
        paletteIndex = 0;
      paletteSwitchTime = System.currentTimeMillis();
    }
    //dome.sendData(map.applyMap());
  }
  
  class Star {
    PGraphics pg;
    PVector v1, v2;
  
    float r, g, b;
    float distance, delta1 = 0, delta2 = 0;
  
    Star(PGraphics pg, float i, float d) {
      this.pg = pg;
      v1 = new PVector(sin(radians(i)), cos(radians(i)));
      v2 = v1.get();
      float[][] palette = (float[][])palettes.get(paletteIndex);
      int idx = (int)random(palette.length);
      r = palette[idx][0];
      g = palette[idx][1];
      b = palette[idx][2];
      distance = d;
    }
  
    void draw() {
      pg.stroke(r, g, b);
      pg.line(v1.x * delta1, v1.y * delta1, v2.x * delta2, v2.y * delta2);
    }
  
    void move() {
      if (delta1 < distance) {
        delta1 += speed;
      } else if (delta2 >= distance) {
        delta1 = 0;
      }
      if (delta1 > distance / 4 && delta2 < distance ) {
        delta2 += speed;
      } else {
        delta2 = 0;
      }
      if (delta1 == 0 && delta2 == 0) {
        stars.remove(this);
      }
    }
  } // class Star

} // class RoutineShootingStars