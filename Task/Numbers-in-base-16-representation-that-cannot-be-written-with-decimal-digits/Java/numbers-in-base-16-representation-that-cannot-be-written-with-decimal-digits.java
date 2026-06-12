import module java.base;

public final class NumbersInBase16RepresentationThatCannotBeWrittenWithDecimalDigits {

	public static void main() {
		IntStream.range(0, 500).mapToObj( n -> Integer.toString(n, 16) )
			.filter( s -> s .chars().allMatch( ch -> "abcdef".contains(Character.toString(ch)) ) )
			.forEach( s -> IO.print(Integer.parseInt(s, 16) + " ") );
	}

}
