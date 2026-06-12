import java.util.concurrent.ThreadLocalRandom;

public final class LargestFiveAdjacentNumber {

	public static void main(String[] args) {
		ThreadLocalRandom random = ThreadLocalRandom.current();
		
		StringBuilder builder = new StringBuilder();
		builder.append(random.nextInt(1, 10));
		for ( int i = 0; i < 999; i++ ) {
			builder.append(random.nextInt(0, 10));
		}
		String digits = builder.toString();
		
		int maximum = Integer.MIN_VALUE;
		int minimum = Integer.MAX_VALUE;
		for ( int i = 0; i < digits.length() - 4; i++ ) {
			final int number = Integer.valueOf(digits.substring(i, i + 5));
			if ( number > maximum ) {
				maximum = number;
			}
			if ( number < minimum ) {
				minimum = number;
			}
		}
		
		System.out.println("Maximum = " + maximum + " and minimum = " + minimum);
	}

}
