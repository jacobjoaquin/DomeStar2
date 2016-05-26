public class MovieFactory implements RoutineFactory {
  public Routine create(PApplet parent) {
    return new RoutineMovie(parent);
  }
}

public class RoutineMovie extends Routine {
  Movie movie;
  
  public RoutineMovie(PApplet parent) {
    super(450, 450);
    
    File dir = new File(dataPath("movies"));
    File[] files = dir.listFiles();
    File file = files[int(random(0,files.length))];
    
    movie = new Movie(parent, file.getAbsolutePath());
  }

  public void setup() {
    movie.loop();
  }
  
  public void draw() {
    if (movie.available())
      movie.read();
    
    pg.image(movie, (450-360)/-2, (450-360)/-2);    
  }
 
 
  
}