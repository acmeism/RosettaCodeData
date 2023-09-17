import java.util.List;

public final class QuotingConstructs {

	public static void main(String[] args) {
		// Java uses double quotes for strings and single quotes for characters.
		String simple = "This is a simple string";
		char letter = 'A';
		
		// A Text Block is denoted by triple quotes.
		String multiLineString = """
                This is an example of multi-line string.
                    Text formatting is preserved.
                Text blocks can be used for multi-line string.
                """;
		System.out.println(multiLineString);
		
		// Java's primitive data types: boolean, byte, char double, float, int, long, short,
		// can be used to to store data, for example,
		final int blockLength = 64;
		
		// Arrays or lists of these data types are possible, for example,
		double[] state = new double[] { 1.0, 2.0, 3.0 };
		
		// Custom data types can be stored in a record or a class, for example,
		record Circle(int centreX, int centreY, double radius) {}
		
		// A list of custom data types:
		List<Circle> circles = List.of( new Circle(1, 2, 1.25), new Circle(-2, 3, 2.50) );
	}

}
