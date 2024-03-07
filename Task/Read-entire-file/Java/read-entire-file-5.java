import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

public class ReadAll {
    public static void main(String[] args) {
        System.out.print(Files.readString(Path.of(args[0], StandardCharsets.UTF_8)));
    }
}
