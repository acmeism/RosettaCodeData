import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths

class CreateFile {
    static void main(String[] args) throws IOException {
        String os = System.getProperty("os.name")
        if (os.contains("Windows")) {
            Path path = Paths.get("tape.file")
            Files.write(path, Collections.singletonList("Hello World!"))
        } else {
            Path path = Paths.get("/dev/tape")
            Files.write(path, Collections.singletonList("Hello World!"))
        }
    }
}
