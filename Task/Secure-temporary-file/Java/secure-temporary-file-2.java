import java.io.BufferedWriter;
import java.nio.file.Files;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;

public final class SecureTemporaryFile {

    public static void main(String[] args) throws IOException  {
        // Create a temporary file in the directory D:\.
        // We should use java.nio.file.Files instead of the old java.io.File, as it is more secure.
        // If the file cannot be created, it will throw an exception.
        Path temporaryFilePath = Files.createTempFile(Path.of("D:/"), "example", ".tmp");

        // For uniqueness, the Java API will insert a random number between the given prefix
        // and the file extension.
        System.out.println("Temporary file created: " + temporaryFilePath);

        // Opening it with the following option will cause the file to be deleted when it is closed.
        BufferedWriter tempFileWriter = Files.newBufferedWriter(
                temporaryFilePath, StandardOpenOption.DELETE_ON_CLOSE);
        // ... write to file, read it back in, close it...
    }

}
