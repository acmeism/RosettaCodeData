import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class FirstClassEnvironments {

	public static void main(String[] aArgs) {
		code();
	}
	
	private static void code() {
		do {
	        for ( int job = 0; job < JOBS; job++ ) {
	            switchTo(job);
	            hailstone();
	        }
	        System.out.println();	
	    } while ( ! allDone() );

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
	
	private static void switchTo(int aID) {
	    if ( aID != currentId ) {
	        environments.get(currentId).seq = sequence;
	        environments.get(currentId).count = count;
	        currentId = aID;
	    }
	
	    sequence = environments.get(aID).seq;
	    count = environments.get(aID).count;
	}	
	
	private static class Environment {
		
		public Environment(int aSeq, int aCount) {
			seq = aSeq; count = aCount;
		}
		
		private int seq, count;
		
	}
	
	private static int sequence, count, currentId;	
	private static List<Environment> environments =
		IntStream.rangeClosed(1, 12).mapToObj( i -> new Environment(i, 0 ) ).collect(Collectors.toList());
	
	private static final int JOBS = 12;

}
