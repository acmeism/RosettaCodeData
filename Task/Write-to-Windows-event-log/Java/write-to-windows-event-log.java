import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Locale;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

public class WriteToWindowsEventLog {
    public static void main(String[] args) throws IOException, InterruptedException {
        String osName = System.getProperty("os.name").toUpperCase(Locale.ENGLISH);
        if (!osName.startsWith("WINDOWS")) {
            System.err.println("Not windows");
            return;
        }

        Process process = Runtime.getRuntime().exec("EventCreate /t INFORMATION /id 123 /l APPLICATION /so Java /d \"Rosetta Code Example\"");
        process.waitFor(10, TimeUnit.SECONDS);
        int exitValue = process.exitValue();
        System.out.printf("Process exited with value %d\n", exitValue);
        if (exitValue != 0) {
            InputStream errorStream = process.getErrorStream();
            String result = new BufferedReader(new InputStreamReader(errorStream))
                .lines()
                .collect(Collectors.joining("\n"));
            System.err.println(result);
        }
    }
}
