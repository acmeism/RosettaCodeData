import java.util.function.Function;

public final class SumOfDigitsOfNIsASubstringOfN {

	public static void main(String[] args) {
		Function<Integer, Integer> digitSum = n -> {
			int sum = 0;
			while ( n > 0 ) {
				sum += n % 10;
				n /= 10;
			}
			return sum;
		};

		for ( int n = 0, count = 0; n < 1_000; n++ ) {
			if ( String.valueOf(n).contains(String.valueOf(digitSum.apply(n))) ) {
				count += 1;
				System.out.print("%3d%s".formatted(n, ( count % 8 == 0 ? "\n" : " " )));
			}
		}
	}

}
