import java.io.InputStream;
import java.util.Scanner;

public class InputLoop {
    public static void main(String args[]) {
        // To read from stdin:
        InputStream source = System.in;

        /*
        Or, to read from a file:
        InputStream source = new FileInputStream(filename);

        Or, to read from a network stream:
        InputStream source = socket.getInputStream();
        */

        Scanner in = new Scanner(source);
        while(in.hasNext()){
            String input = in.next(); // Use in.nextLine() for line-by-line reading

            // Process the input here. For example, you could print it out:
            System.out.println(input);
        }
    }
}
