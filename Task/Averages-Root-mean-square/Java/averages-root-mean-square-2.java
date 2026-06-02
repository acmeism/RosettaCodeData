import module java.base;

public final class AveragesRootMeanSquare {

	public static void main() {
		IO.println(Math.sqrt(IntStream.rangeClosed(1, 10).map( i -> i * i ).average().orElse(0.0)));
	}

}
