public class KaleFactory implements RoutineFactory {
  public Routine create(PApplet parent) {
    return new RoutineKaleidoscope();
  }
}

public class RoutineKaleidoscope extends Routine {

  public RoutineKaleidoscope() {
    super(450, 450);
  }
  
  PImage img;
  
  LightArcs arcs;
  Shockwave wave;
  Kaleidoscope ks;
  
  public void setup() {
    arcs = new LightArcs();
    wave = new Shockwave();
    
    ks = new Kaleidoscope();
  }
  
  public void draw() {  
    pg.colorMode(RGB);
    pg.background(0);
     
    arcs.step();
    wave.step();
    
    if (ks.step()) {
        arcs.reset();
        wave.reset();
        ks.reset();
    }
      
    arcs.draw();
    wave.draw();
    ks.draw();
  }
  
  private class Kaleidoscope {
    PImage image;
    ArrayList<ImageSpin> spinners;
    int count;
    
    public Kaleidoscope() {
      this.image = image;
      this.spinners = new ArrayList<ImageSpin>();
      this.reset();
    }
    
    public void reset() {
      File dir = new File(dataPath("images"));
      File[] files = dir.listFiles();
      File file = files[int(random(0,files.length))];
      this.image = loadImage(file.getAbsolutePath());

      this.count = 1;
      this.setupSpinners();
    }
  
    private void setupSpinners() {
      int size = int(400 / (this.count * 0.75));
      int offset = this.count > 1 ? 90 : 0;
      spinners.clear();
      for (int i=0; i<this.count; i++) {
        spinners.add(new ImageSpin(image, size, offset, TWO_PI/this.count*i)); 
      }
    }
    
    public boolean step() {
      
      boolean result = true;
      for (ImageSpin spinner : spinners) {
        result = spinner.step() && result;
      }
      
      if (result) {
        this.count = this.count * 2;
        this.setupSpinners();
        
        if (this.count >= 8)
          return true;
      }
      
      return false;
    }
    
    public void draw() {
      for (ImageSpin spinner : spinners) {
        spinner.draw();
      }
    }
  }
  
  private class ImageSpin {
    float angle;
    float size;
    PImage image;
    int count;
    float magnitude;
    int stickFrames;
    float maxSize;
    float offset;
    
   public ImageSpin(PImage image, float maxSize, float offset, float angle) {
     this.image = image;
     this.angle = angle;
     this.size = 10;
     this.magnitude = 1.03;
     this.stickFrames = 300;
     this.maxSize = maxSize;
     this.offset = offset;
   }
   
   public boolean step() {
     this.angle += PI/100;
     this.size = this.size * this.magnitude;
     
     if (this.size > maxSize) {
       this.size = maxSize;
       this.stickFrames--;
       
       if (this.stickFrames <= 0)
         this.magnitude = 0.9;     
     }
     else if (this.size < 10) {
       this.magnitude = 1.03;
       this.size = 10;
       this.stickFrames = 300;
       return true;
     }      
     
     return false;
   }
   
   public void draw() {
      pg.pushMatrix();
      pg.translate(180,180);
      if (this.offset > 0) {
        pg.rotate(this.angle);
        pg.translate(this.offset, this.offset);
      }
      pg.rotate(this.angle);
      pg.translate(-this.size/2, -this.size/2);        
      pg.image(this.image, 0, 0, this.size, this.size);
      pg.popMatrix();
   }
  }
    
  private class Shockwave {
    float radius;
    boolean done;
    
    public Shockwave() {
      this.reset();
    }
  
    public void reset() {
      radius = 1.05;
      done = false;
    }
    
    public boolean step() {  
      if (!done) {
        radius *= 1.07;
        done = radius > 2000;
      }
      
      return done;
    }
    
    public void draw() {
      if (!done && radius>10) {
        pg.ellipseMode(RADIUS);
        pg.noStroke();
        
        pg.fill(0);
        pg.ellipse(180,180,radius,radius);
        
        if (radius>20) {
          pg.fill(getColor());
          pg.ellipse(180,180,radius*.85,radius*.85);
        }
    
        if (radius > 50) {
          pg.fill(0);
          pg.ellipse(180,180,radius-50,radius-50);
        }
      }
    }
  }
  
  private class LightArcs {
      boolean done;
      LightArc[] arcs;
      
      public LightArcs() {
        arcs = new LightArc[16];
        for (int i=0; i<arcs.length; i++) {
            arcs[i] = new LightArc();
        }
        done = false;
      }
      
      public boolean step() {
        boolean result = true;
        
        for (int i=0; i<arcs.length; i++) {
          result = arcs[i].step() && result;
        }
        
        done = result;
        return result;
      }
      
      public void reset() {
        for (int i=0; i<arcs.length; i++) {
          arcs[i].reset();
        }
      }
      
      public void draw() {
        if (!done) {
          for (int i=0; i<arcs.length; i++) {
            arcs[i].draw();
          }
        }
      }
  }
  
  private class LightArc {
    float angle;
    int size;
    int len;
  
    public LightArc() {
      this.reset();
    }
    
    public LightArc(float angle, int size, int len) {
      this.angle = angle;
      this.size = size;
      this.len = len;
    }
    
    public boolean step() {
      if (len >= 360) {        
        size = int(size * 1.05);  
      }
      else {
        len = int(len * 1.1);
      }
      return size > 200;
    }
    
    public void reset() {
      this.angle = random(0, TWO_PI);
      this.size = int(random(20, 60));
      this.len = int(random(10, 20));    
    }
    
    public void draw() {
      int half = int(size/2 * (len/360.0));
      color col = getColor();

      pg.pushMatrix();
      pg.pushStyle();
    
      pg.translate(180, 180);
      pg.rotate(angle);
      pg.noStroke();
      pg.fill(red(col),green(col),blue(col),64);
      pg.triangle(0, 0, half+7, len, -half-7, len);
      pg.fill(red(col),green(col),blue(col),127);
      pg.triangle(0, 0, half+5, len, -half-5, len);
      pg.fill(col);
      pg.triangle(0, 0, half, len, -half, len);
    
      pg.popStyle();
      pg.popMatrix();
    } 
  }
}