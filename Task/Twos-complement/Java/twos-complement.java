import java.util.List;

public final class TwosComplement {

	public static void main(String[] args) {
		List<Integer> examples = List.of( 0, 1, -1, 42 );
		
		System.out.println(String.format("%9s%12s%24s%34s", "decimal", "hex", "binary", "two's complement"));
		System.out.println(
            String.format("%6s%12s%24s%32s", "-----------", "--------", "----------", "----------------"));
		
		for ( int example : examples ) {
			System.out.println(String.format("%5d%18s%36s%13d",
                example, toHex(example), toBinary(example), twosComplement(example)));
		}
	}
	
	private static String toHex(int number) {
		return String.format("%8s", Integer.toHexString(number).toUpperCase()).replace(" ", "0");
	}
	
	private static String toBinary(int number) {
		return String.format("%32s", Integer.toBinaryString(number)).replace(" ", "0");
	}
	
	private static int twosComplement(int number) {
		return ~number + 1;
	}

}
