import module java.base;

public final class SumOfASeries {

	public static void main() {
		IO.println(IntStream.rangeClosed(1, 1_000).mapToDouble( i -> 1.0 / ( i * i ) ).sum());
	}

}
