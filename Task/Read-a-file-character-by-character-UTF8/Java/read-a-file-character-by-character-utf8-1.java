import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

public class Program {
    private final FileReader reader;

    public Program(String path) throws IOException {
        reader = new FileReader(path, StandardCharsets.UTF_16);
    }

    /** @return integer value from 0 to 0xffff, or -1 for EOS */
    public int nextCharacter() throws IOException {
        return reader.read();
    }

    public void close() throws IOException {
        reader.close();
    }
}
