import java.util.List;
import java.util.stream.Collectors;

public final class UniqueCharacters {

	public static void main(String[] args) {
		System.out.println(String.join("", List.of( "133252abcdeeffd", "a6789798st","yxcdfgxcyz" ))
			.chars().boxed().collect(Collectors.toMap( k -> (char) k.intValue(), v -> 1, Integer::sum))
			.entrySet().stream().filter( e -> e.getValue() == 1 ).map( e -> e.getKey() ).sorted().toList());
	}

}
