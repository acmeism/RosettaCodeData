import java.util.Comparator;
import java.util.List;
import java.util.stream.IntStream;

public final class MinimumNumbersOfThreeLists {

	public static void main(String[] args) {
		List<Integer> numbers1 = List.of(  5, 45, 23, 21, 67 );
		List<Integer> numbers2 = List.of( 43, 22, 78, 46, 38 );
		List<Integer> numbers3 = List.of(  9, 98, 12, 98, 53 );
		
		List<Integer> numbers = IntStream.range(0, 5)
			.map( i -> List.of( numbers1.get(i), numbers2.get(i), numbers3.get(i) )
			.stream().min(Comparator.naturalOrder()).get() ).boxed().toList();
		
		System.out.println(numbers);
	}

}
