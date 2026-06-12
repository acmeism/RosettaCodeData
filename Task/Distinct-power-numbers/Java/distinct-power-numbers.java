import java.util.Set;
import java.util.TreeSet;

public final class DistinctPowerNumbers {

	public static void main(String[] args) {
		Set<Integer> values = new TreeSet<Integer>();
	    for ( int a = 2; a <= 5; a++ ) {
	        for ( int b = 2; b <= 5; b++ ) {
	            values.add((int) Math.pow(a, b));
	        }
	    }
	
	    System.out.println(values);
	}

}
