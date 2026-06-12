import java.util.List;

public final class SealedClassesAndMethods {

	public static void main(String[] args) {
	    List<MovieWatcher> movieWatchers = List.of( new ParentMovieWatcher("Donald"),
	    											new ChildMovieWatcher("Lisa"),
	    											new YoungChildMovieWatcher("Fred") );
	
	    for ( MovieWatcher movieWatcher : movieWatchers ) {
	        movieWatcher.watchMovie();
	        movieWatcher.eatPopcorn();
	    }
	}
}

// Base class for MovieWatcher's
class MovieWatcher {	

	public MovieWatcher(String aName) {
		name = aName;
	}

    public void watchMovie() {
    	System.out.println(name + " is watching the movie");
    }

    public void eatPopcorn() {
        System.out.println(name + " is eating popcorn");
    }

    private final String name;

}

// ParentMovieWatcher cannot be extended because it is 'final'
final class ParentMovieWatcher extends MovieWatcher {

	public ParentMovieWatcher(String aName) {
		super(aName);
	}
	
}

// ChildMovieWatcher can be extended.
class ChildMovieWatcher extends MovieWatcher {

	public ChildMovieWatcher(String aName) {
		super(aName);
		name = aName;
	}

	// The method eatPopcorn() cannot be overridden because it is 'final'
	public final void eatPopcorn() {
		System.out.println(name + " is eating too much popcorn");
	}
	
	private String name;
}

class YoungChildMovieWatcher extends ChildMovieWatcher {

	public YoungChildMovieWatcher(String aName) {
		super(aName);
		name = aName;
	}

    // The method watchMovie() cannot be overridden because it is 'final'
    public final void watchMovie() {
        System.out.println(name + ", you are too young to watch the movie.");
    }

    private String name;

}
