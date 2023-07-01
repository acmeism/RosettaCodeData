import java.io.BufferedReader;
import java.io.FileReader;

public class KernighansLargeEarthquakeProblem {

    public static void main(String[] args) throws Exception {
        try (BufferedReader reader  = new BufferedReader(new FileReader("data.txt")); ) {
            String inLine = null;
            while ( (inLine = reader.readLine()) != null ) {
                String[] split = inLine.split("\\s+");
                double magnitude = Double.parseDouble(split[2]);
                if ( magnitude > 6 ) {
                    System.out.println(inLine);
                }
            }
        }

    }

}
