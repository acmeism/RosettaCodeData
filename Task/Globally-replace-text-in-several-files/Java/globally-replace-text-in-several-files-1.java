import java.io.*;
import java.nio.file.*;

public class GloballyReplaceText {

    public static void main(String[] args) throws IOException {

        for (String fn : new String[]{"test1.txt", "test2.txt"}) {
            String s = new String(Files.readAllBytes(Paths.get(fn)));
            s = s.replace("Goodbye London!", "Hello New York!");
            try (FileWriter fw = new FileWriter(fn)) {
                fw.write(s);
            }
        }
    }
}
