import java.util.AbstractMap;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

public final class DecorateSortUndecorateIdiom {	

	public static void main(String[] args) {
		List<String> list = List.of( "Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site" );
		System.out.println(schwartzian(list, s -> s.length()));
	}
	
    /**
	 * Return a sorted list using the Schwartzian Transform
	 * which guarantees minimal use of the key extractor function.
	 *
	 * Use this method when the key extractor function is an expensive operation.
	 */
	private static <T, R extends Comparable<R>> List<T> schwartzian(List<T> list, Function<T, R> function) {
		return list.stream().map( s -> new AbstractMap.SimpleEntry<T, R>(s, function.apply(s)) )
							.sorted( (one, two) -> one.getValue().compareTo(two.getValue()) )
							.map( p -> p.getKey() )
                            .collect(Collectors.toList());
	}	

}
