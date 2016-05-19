public class RoutinePermutatingRect extends Routine {
  
  private class Permutation {
    /**
     * Represents a value that changes over time, in this case with each call
     */
    float value;
    float delta;
    float multiplier;
    float min;
    float max;
    
    public Permutation(float value, float delta, float multiplier) {
      this.value = value;
      this.delta = delta;
      this.multiplier = multiplier;
      this.min = -Float.MAX_VALUE;
      this.max = Float.MAX_VALUE;
    }
    
    public Permutation(float value, float delta, float multiplier, float min, float max) {
      this.value = value;
      this.delta = delta;
      this.multiplier = multiplier;
      this.min = min;
      this.max = max;
    }
    
    public void permutate() {
      value = (value + delta) * multiplier;
      
      while (value > this.max)
        value -= this.max;
        
      while (value < this.min)
        value += this.max;
    }
  }
  
  Permutation rotation = new Permutation(random(180), PI/128, 1, 0, 180);
  Permutation velocity = new Permutation(PI/128, PI/102400, 1);
  
  public void setup() {
    pg.background(0);
    pg.colorMode(HSB);
    pg.noFill();
    pg.rectMode(CENTER);
    pg.strokeWeight(8);
  }
  
  void permutatingRect(Permutation size, Permutation rotation, Permutation hue,
                     Permutation saturation, Permutation brightness, 
                     Permutation count) 
  {
    while (count.value > 0) {
      // Shoot a bright rect through every so often.. Kinda hacky.
      if ((frameCount / 4) % 24 == count.value)
        pg.stroke(hue.value, saturation.value, 254, 255);
      else
        pg.stroke(hue.value, saturation.value, brightness.value, 127);
   
      // Draw our rect
      pg.pushMatrix();
      pg.rotate(rotation.value);
      pg.rect(0, 0, size.value, size.value);
      pg.popMatrix();
  
      // Permutate all our values
      size.permutate();
      rotation.permutate();
      hue.permutate();
      saturation.permutate();
      brightness.permutate();
      count.permutate();
    }
  }
  
  public void draw() {    
    // Our base rotation delta changes over time so that we see the patterns change
    // We bounce betweeen PI/64 and PI/128 rotation deltas to keep it subtle.
    velocity.permutate();
    rotation.delta = velocity.value;
    rotation.permutate();
    
    if (velocity.value > PI/64 || velocity.value < PI/128) {
      velocity.delta = -velocity.delta;
    }
  
    pg.background(0);  
    pg.pushMatrix();    
    pg.translate(pg.width/2, pg.height/2);
    
    permutatingRect(
      new Permutation(510, -34, 1),                      // Size, from outside going in
      new Permutation(rotation.value, PI/16, 1.025),     // Rotation, PI/16 * 103.33%
      new Permutation(127, 0, 1),                        // Hue, static for now
      new Permutation(0, 0, 1),                          // Saturation, static for now
      new Permutation(254, -8, 1, 0, 255),               // Brightness, toward dark, capped
      new Permutation(int(pg.width/30), -1, 1)                         // Count, 14
    );
    pg.popMatrix();    
  }
}