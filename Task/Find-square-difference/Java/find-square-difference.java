import java.util.stream.IntStream;

public final class FindSquareDifference {

	public static void main(String[] args) {
		System.out.println(IntStream.rangeClosed(1, 1_000).filter( i -> 2 * i - 1 > 1_000 ).findFirst().getAsInt());
	}

}
