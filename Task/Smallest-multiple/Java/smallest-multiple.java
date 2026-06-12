import java.util.stream.IntStream;

public final class SmallestMultiple {

	public static void main(String[] args) {
		System.out.println(IntStream.rangeClosed(1, 20).reduce(1, (total, number) -> lcm(total, number) ));
	}
	
	private static int lcm(int a, int b) {
		final int largerNumber = Math.max(a, b);
	    final int smallerNumber = Math.min(a, b);
	    int lcm = largerNumber;
	    while ( lcm % smallerNumber != 0) {
	        lcm += largerNumber;
	    }
	    return lcm;
	}
	
}
