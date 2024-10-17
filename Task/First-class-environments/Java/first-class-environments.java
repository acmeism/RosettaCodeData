import java.util.List;
import java.util.stream.IntStream;

public final class FirstClassEnvironments {

	public static void main(String[] args) {
		code();
	}
	
	private static void code() {
		while ( ! allDone() ) {
	        for ( int job = 0; job < JOBS; job++ ) {
	            switchTo(job);
	            hailstone();
	        }
	        System.out.println();	
	    }

	    System.out.println(System.lineSeparator() + "Counts:");
	    for ( int job = 0; job < JOBS; job++ ) {
	        switchTo(job);
	        System.out.print(String.format("%4d", count));
	    }
	    System.out.println();
	}
	
	private static boolean allDone() {	
		for ( int job = 0; job < JOBS; job++ ) {
	        switchTo(job);
	        if ( sequence > 1 ) {
	        	return false;
	        }
	    }
	    return true;
	}
	
	private static void hailstone() {
	    System.out.print(String.format("%4d", sequence));
	    if ( sequence == 1 ) {
	    	return;
	    }
	
	    count += 1;
	    sequence = ( sequence % 2 == 1 ) ? 3 * sequence + 1 : sequence / 2;
	}
	
	private static void switchTo(int id) {
	    if ( id != currentId ) {
	        environments.get(currentId).sequence = sequence;
	        environments.get(currentId).count = count;
	        currentId = id;
	    }
	
	    sequence = environments.get(id).sequence;
	    count = environments.get(id).count;
	}	
	
	private static class Environment {
		
		public Environment(int aSequence, int aCount) {
			sequence = aSequence; count = aCount;
		}
		
		private int sequence, count;
		
	}
	
	private static int sequence, count, currentId;	
	private static List<Environment> environments =
		IntStream.rangeClosed(1, 12).mapToObj( i -> new Environment(i, 0) ).toList();
	
	private static final int JOBS = 12;

}
