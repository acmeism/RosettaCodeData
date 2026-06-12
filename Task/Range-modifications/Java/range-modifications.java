import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

public final class RangeModifications {

	public static void main(String[] args) {
		Ranges ranges = new Ranges(List.of());
	    System.out.println("Initial ranges = " + ranges);
	    displayAdd(ranges, 77);
	    displayAdd(ranges, 79);
	    displayAdd(ranges, 78);
	    displayRemove(ranges, 77);
	    displayRemove(ranges, 78);
	    displayRemove(ranges, 79);	
	
	    ranges = new Ranges(List.of( new Range(1, 3), new Range(5, 5) ));
	    System.out.println("\nInitial ranges = " + ranges);
	    displayAdd(ranges, 1);
	    displayRemove(ranges, 4);
	    displayAdd(ranges, 7);
	    displayAdd(ranges, 8);
	    displayAdd(ranges, 6);
	    displayRemove(ranges, 7);
	
	    ranges = new Ranges(List.of( new Range(1, 5), new Range(10, 25), new Range(27, 30) ));
	    System.out.println("\nInitial ranges = " + ranges);
	    displayAdd(ranges, 26);
	    displayAdd(ranges, 9);
	    displayAdd(ranges, 7);
	    displayRemove(ranges, 26);
	    displayRemove(ranges, 9);
	    displayRemove(ranges, 7);
	}
	
	private static void displayAdd(Ranges ranges, int n) {
		ranges.add(n);
		System.out.println("       add %2d => %s".formatted(n, ranges));
	}

	private static void displayRemove(Ranges ranges, int n) {
		ranges.remove(n);
		System.out.println("    remove %2d => %s".formatted(n, ranges));
	}
}

final class Ranges {
	
	public Ranges(List<Range> aRanges) {
		ranges = new ArrayList<Range>(aRanges);
	}
	
	public void add(int n) {		
		for ( ListIterator<Range> iterator = ranges.listIterator(); iterator.hasNext(); ) {
			Range current = iterator.next();
			
		    if ( n + 1 < current.low ) {
		    	iterator.previous();
	            iterator.add( new Range(n, n) );
	        } else if ( n + 1 == current.low ) {
	            current.low = n;
	        } else if ( n <= current.high ) {
	        	// No action required
	        } else if ( n - 1 == current.high ) {
	            current.high = n;
	            if ( iterator.hasNext() ) {
	            	Range next = iterator.next();
	            	if ( n == next.low || n + 1 == next.low ) {
	            		current.high = next.high;
	            		iterator.remove();
	            	}
	            }
	        } else if ( ! iterator.hasNext() ) {
	            iterator.add( new Range(n, n) );
	        } else {
	        	continue;
	        }
		
			return;
	    }
		
	    ranges.addLast( new Range(n, n) );	
	}
	
	public void remove(int n) {		
		for ( ListIterator<Range> iterator = ranges.listIterator(); iterator.hasNext(); ) {
			Range current = iterator.next();
			
	        if ( n == current.low ) {
	        	current.low = n + 1;
	            if ( current.low > current.high ) {
	                iterator.remove();
	            }
	        } else if ( n == current.high ) {
	        	current.high = n - 1;
	            if ( current.high < current.low ) {
	                iterator.remove();
	            }
	        } else if ( n > current.low && n < current.high ) {
	            final int high = current.high;
	            current.high = n - 1;
	            iterator.add( new Range(n + 1, high) );
	        }
	    }		
	}
	
	public String toString() {
		return ranges.toString();
	}
	
	private List<Range> ranges;
	
}

final class Range {
	
	public Range(int aLow, int aHigh) {
		low = aLow;
		high = aHigh;
	}

	public String toString() {
		return low + "-" + high;
	}
	
	public int low;
	public int high;
	
}
