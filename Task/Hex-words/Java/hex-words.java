import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public final class HexWords {

	public static void main(String[] aArgs) throws IOException {
		Set<Character> hexDigits = Set.of( 'a', 'b', 'c', 'd', 'e', 'f' );
		
		List<Item> items = Files.lines(Path.of("unixdict.txt"))
								.filter( word -> word.length() >= 4 )
								.filter( word -> word.chars().allMatch( ch -> hexDigits.contains((char) ch) ) )			
								.map( word -> { final int value = Integer.parseInt(word, 16);
												return new Item(word, value, digitalRoot(value));
											  } )
								.collect(Collectors.toList());

		Collections.sort(items, Comparator.comparing(Item::getDigitalRoot).thenComparing(Item::getWord));	
		display(items);		
		
		List<Item> filteredItems = items.stream()
			.filter( item -> item.aWord.chars().mapToObj( ch -> (char) ch ).collect(Collectors.toSet()).size() >= 4 )
			.collect(Collectors.toList());		
		
		Collections.sort(filteredItems, Comparator.comparing(Item::getNumber).reversed());	
		display(filteredItems);
	}		

	private static int digitalRoot(int aNumber) {
	    int result = 0;
    	while ( aNumber > 0 ) {
    		result += aNumber % 10;
    		aNumber /= 10;
    	}
	    return ( result <= 9 ) ? result : digitalRoot(result);		
	}
	
	private static void display(List<Item> aItems) {			
		System.out.println("  Word      Decimal value   Digital root");
		System.out.println("----------------------------------------");
		for ( Item item : aItems ) {
		    System.out.println(String.format("%7s%15d%12d", item.aWord, item.aNumber, item.aDigitalRoot));
		}
		System.out.println(System.lineSeparator() + "Total count: " + aItems.size() + System.lineSeparator());
	}	
	
	private static record Item(String aWord, int aNumber, int aDigitalRoot) {
				
		public String getWord() { return aWord; }
		
		public int getNumber() { return aNumber; }
		
		public int getDigitalRoot() { return aDigitalRoot; }
		
	}

}
