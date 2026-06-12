import java.util.List;
import java.util.stream.Collectors;

public final class UniqueCharactersInEachString {

	public static void main(String[] args) {
		System.out.println(List.of( "1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz" ).stream()
			.map( s -> s.chars().boxed()
			.collect(Collectors.toMap( k -> (char) k.intValue(), v -> 1, Integer::sum )).entrySet().stream()
			.filter( e -> e.getValue() == 1 ).map( e -> e.getKey() ).sorted().collect(Collectors.toList()) )
			.toList().stream().reduce( (a, b) -> { a.retainAll(b); return a; } ).get());		
	}

}
