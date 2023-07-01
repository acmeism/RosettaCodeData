import java.util.ArrayList;
import java.util.List;

public final class Padovan {

	public static void main(String[] aArgs) {
		for ( int i = 0; i < 64; i++ ) {
			recurrences.add(padovanRecurrence(i));
			floors.add(padovanFloor(i));
		}		
		
		System.out.println("The first 20 terms of the Padovan sequence:");
		recurrences.subList(0, 20).forEach( term -> System.out.print(term + " ") );		
		System.out.println(System.lineSeparator());
		
		System.out.print("Recurrence and floor functions agree for first 64 terms? " + recurrences.equals(floors));
		System.out.println(System.lineSeparator());
		
		List<String> words = createLSystem();		
		
		System.out.println("The first 10 terms of the L-system:");
		words.subList(0, 10).forEach( term -> System.out.print(term + " ") );		
		System.out.println(System.lineSeparator());
		
		System.out.print("Length of first 32 terms produced from the L-system match Padovan sequence? ");		
		List<Integer> wordLengths = words.stream().map( s -> s.length() ).toList();
		System.out.println(wordLengths.equals(recurrences.subList(0, 32)));
	}
	
	private static int padovanRecurrence(int aN) {
		return ( aN <= 2 ) ? 1 : recurrences.get(aN - 2) + recurrences.get(aN - 3);		
	}
	
	private static int padovanFloor(int aN) {
		return (int) Math.floor(Math.pow(PP, aN - 1) / SS + 0.5);
	}
	
	private static List<String> createLSystem() {
		List<String> words = new ArrayList<String>();		
		StringBuilder stringBuilder = new StringBuilder();
		String text = "A";
		
		do {
			words.add(text);
			stringBuilder.setLength(0);
			for ( char ch : text.toCharArray() ) {
				String entry = switch ( ch ) {
					case 'A' -> "B";
					case 'B' -> "C";
					case 'C' -> "AB";
					default -> throw new AssertionError("Unexpected character found: " + ch);
				};
				
				stringBuilder.append(entry);
			}
			
			text = stringBuilder.toString();
		} while ( words.size() < 32 );
		
		return words;
	}
	
	private static List<Integer> recurrences = new ArrayList<Integer>();
	private static List<Integer> floors = new ArrayList<Integer>();
	
	private static final double PP = 1.324717957244746025960908854;
	private static final double SS = 1.0453567932525329623;

}
