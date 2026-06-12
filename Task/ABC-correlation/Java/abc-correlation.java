import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;

public final class ABCCorrelation {

    public static void main(String[] args) throws IOException {
        Predicate<String> abc = word -> {
            Map<Character, Integer> charMap = new HashMap<Character, Integer>();
            List<Character> wanted = List.of( 'a', 'b', 'c' );
            word.chars().filter( i -> wanted.contains((char) i) )
                        .forEach( ch -> charMap.merge((char) ch, 1, Integer::sum) );
            return wanted.stream().allMatch( ch -> charMap.keySet().contains(ch) && charMap.get(ch) == 2 );
        };

        Files.lines(Path.of("words_alpha.txt")).filter( w -> abc.test(w) ).forEach(System.out::println);
    }

}
