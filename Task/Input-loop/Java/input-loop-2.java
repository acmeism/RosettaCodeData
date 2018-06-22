import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;

public class InputLoop {
    public static void main(String args[]) {
        // To read from stdin:
        Reader reader = new InputStreamReader(System.in);

        /*
        Or, to read from a file:
        Reader reader = new FileReader(filename);

        Or, to read from a network stream:
        Reader reader = new InputStreamReader(socket.getInputStream());
        */

        try {
            BufferedReader inp = new BufferedReader(reader);
            while(inp.ready()) {
                int input = inp.read(); // Use in.readLine() for line-by-line

                // Process the input here. For example, you can print it out.
                System.out.println(input);
            }
        }  catch (IOException e) {
            // There was an input error.
        }
    }
}
