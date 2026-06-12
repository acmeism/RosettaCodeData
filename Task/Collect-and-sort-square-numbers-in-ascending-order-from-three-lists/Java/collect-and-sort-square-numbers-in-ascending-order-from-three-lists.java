import java.util.Collection;
import java.util.List;
import java.util.stream.Stream;

public final class CollectAndSortSquareNumbersInAscendingOrder {

	public static void main(String[] args) {
		List<Integer> one = List.of( 3, 4, 34, 25, 9, 12, 36, 56, 36 );
		List<Integer> two = List.of( 2, 8, 81, 169, 34, 55, 76, 49, 7 );
		List<Integer> three = List.of( 75, 121, 75, 144, 35, 16, 46, 3 );
		
		Stream.of(one, two, three).flatMap(Collection::stream)
			.filter( i -> Math.pow((int) Math.sqrt(i), 2) == i )
			.sorted()
			.forEach( i -> System.out.print(i + " ") );
	}

}
