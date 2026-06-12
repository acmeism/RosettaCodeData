import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class SetTheCardGame {

	public static void main(String[] args) {
		List<Card> pack = createPackOfCards();
		for ( int cardCount : List.of( 4, 8, 12 ) ) {
		    Collections.shuffle(pack);
		    List<Card> deal = pack.subList(0, cardCount);
		    System.out.println("Cards dealt: " + cardCount);
		    for ( Card card : deal ) {
		    	System.out.println(card);
		    }		
		    System.out.println();
		
		    System.out.println("Sets found: ");		
		    for ( List<Card> combination : combinations(deal, 3) ) {
		    	if ( isGameSet(combination) ) {
		    		for ( Card card : combination ) {
		    			System.out.print(card + " ");
		    		}
		    		System.out.println();
		    	}
		    }
		    System.out.println("-------------------------" + System.lineSeparator());
		}
	}
	
	private static interface Feature {}
	
	private static enum Number implements Feature { ONE, TWO, THREE }
	private static enum Colour implements Feature { GREEN, RED, PURPLE }
	private static enum Shading implements Feature { OPEN, SOLID, STRIPED }
	private static enum Shape implements Feature { DIAMOND, OVAL, SQUIGGLE }	
	
	private static record Card(Number number, Colour colour, Shading shading, Shape shape) {
		
		public String toString() {
			return "[" + number + " " + colour + " " + shading + " " + shape + "]";
		}
		
	}
	
	private static List<Card> createPackOfCards() {
		List<Card> pack = new ArrayList<Card>(81);
		for ( Number number : Number.values() ) {
			for  ( Colour colour : Colour.values() ) {
				for ( Shading shading : Shading.values() ) {
					for ( Shape shape : Shape.values() ) {
						pack.add( new Card(number, colour, shading, shape) );
					}
				}
			}
		}	
		return pack;
	}
	
	private static boolean isGameSet(List<Card> triple) {
		return allSameOrAllDifferent(triple.stream().map( c -> (Feature) c.number ).toList()) &&
			   allSameOrAllDifferent(triple.stream().map( c -> (Feature) c.colour ).toList()) &&
			   allSameOrAllDifferent(triple.stream().map( c -> (Feature) c.shading ).toList()) &&
			   allSameOrAllDifferent(triple.stream().map( c -> (Feature) c.shape ).toList());
	}
	
	private static boolean allSameOrAllDifferent(List<Feature> features) {
		Set<Feature> featureSet = new HashSet<Feature>(features);
		return featureSet.size() == 1 || featureSet.size() == 3;
	}	
	
	private static <T> List<List<T>> combinations(List<T> list, int choose) {
		List<List<T>> combinations = new ArrayList<List<T>>();
	    List<Integer> combination = IntStream.range(0, choose).boxed().collect(Collectors.toList());	
	    while ( combination.get(choose - 1) < list.size() ) {   	
	        combinations.add(combination.stream().map( i -> list.get(i) ).toList());	
	        int temp = choose - 1;
	        while ( temp != 0 && combination.get(temp) == list.size() - choose + temp ) {
	            temp -= 1;
	        }
	        combination.set(temp, combination.get(temp) + 1);
	        for ( int i = temp + 1; i < choose; i++ ) {
	        	combination.set(i, combination.get(i - 1) + 1);
	        }
	    }	
	    return combinations;
	}

}
