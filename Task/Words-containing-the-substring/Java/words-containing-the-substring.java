import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public final class WordsContainingTheSubstring {

    public static void main(String[] args) throws IOException {
        Files.lines(Path.of("unixdict.txt"))
             .filter( word -> word.length() > 11 && word.contains("the") )
             .forEach(System.out::println);
    }

}
