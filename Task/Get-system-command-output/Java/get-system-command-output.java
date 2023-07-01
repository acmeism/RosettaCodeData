import java.io.*;
import java.util.*;

public class SystemCommand {

    public static void main(String args[]) throws IOException {

        String command = "cmd /c dir";
        Process p = Runtime.getRuntime().exec(command);

        try (Scanner sc = new Scanner(p.getInputStream())) {

            System.out.printf("Output of the command: %s %n%n", command);
            while (sc.hasNext()) {
                System.out.println(sc.nextLine());
            }
        }
    }
}
