PVector pink = new PVector(255, 62, 181);
PVector white = new PVector(255, 255, 255);
PVector black = new PVector(0, 0, 0);
PVector orange = new PVector(255, 170, 77);

public class PerlinFactory implements RoutineFactory {
  public Routine create() {
    return new PerlinPink();
  }
}

public class PerlinPink extends Routine {
  private PerlinDot[] dots;
  int iteration = int(random(100000000));

  public PerlinPink() {
    super(40, 160);
  }
  
  public void setup() {
    pg.background(0);
    pg.colorMode(RGB);
    pg.rectMode(CORNER);

    dots = new PerlinDot[40 * 160];

    // initialize all the dots
    int index = 0;
    for (int x = 0; x < 40; x++) {
      for (int y = 0; y < 160; y++) {
        dots[index++] = new PerlinDot(x, y);
      }
    }
  }

  public void draw() {
    pg.background(0);
    iteration++;
    
    // change this to some kind of frames per second.
    // decrease if changes on dome are too slow.
    float iterationFactor = iteration / 500.0;
    for (PerlinDot dot : dots) {
      dot.display(iterationFactor);
    }
  }

  class PerlinDot {
    int x, y;
    float lightNum, stripNum;

    // Contructor
    public PerlinDot(int x, int y) {
      this.x = x;
      this.y = y;
      
      // 2 so that the vertical lines are longer.  creates a more falling effect.
      // (adjust according to actual field of view.)
      stripNum = sqrt((x-20) * (x-20) + (y-80) * (y-80)) / 80;

      // using sin, so image with wrap around
      // 89 instead of 90 to make it slight assemetric.
      lightNum = atan2(x-20, y-80) / 2.0;
    }

    void display(float iteration) {
      float it = iteration;

      // noise slowly moves down the dome, with additional changes over time.
      float n = noise(lightNum, stripNum - it, it * .7);

      // pink peeks, white horizon, black valleys, and orange floor.
      PVector r;
      if (n >= .48) {
        r = pink;
      } else if (n >= .45) {
        r = white;
      } else if (n >= .28) {
        r = black;
      } else {
        r = orange;
      }

      // add in a black noisier and faster moving gradient.
      // adds a texture like effect.
      // by moving through time quickly it gives in a shimmering.
      float n2 = noise(lightNum * 3, stripNum * 3, it * 3);
      r = r.copy().mult(2 * n2 - .3);
    
      color c = color(r.x, r.y, r.z);

      pg.fill(c);
      pg.stroke(c);
      pg.rect(x, y, 1, 1);
    }
  }
}