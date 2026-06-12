import java.util.stream.IntStream;

public final class PositiveDecimalNumbersWithTheDigit1OccurringExactlyTwice {

	public static void main(String[] args) {
		System.out.println("Decimal numbers under 1,000 whose digits include exactly two 1's:");
		System.out.println(String.join(" ", IntStream.range(1, 1_000)
			.filter( n -> Boolean.compare(n % 10 == 1, false)
					    + Boolean.compare(n % 100 / 10 == 1, false)
					    + Boolean.compare(n / 100 == 1, false) == 2 )
			.mapToObj(String::valueOf).toList()));
	}

}
