import java.util.function.BiFunction;
import java.util.stream.Collectors;

public final class StripASetOfCharactersFromAString {

	public static void main(String[] args) {
		BiFunction<String, String, String> stripCharacters = (string, characters) -> string.chars()
			.mapToObj(Character::toString).filter( s -> ! characters.contains(s) ).collect(Collectors.joining(""));
		
		System.out.println(stripCharacters.apply("She was a soul stripper. She took my heart!", "aei"));
	}

}
