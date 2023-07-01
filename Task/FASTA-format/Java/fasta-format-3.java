import java.io.*;
import java.util.Scanner;

public class ReadFastaFile {

    public static void main(String[] args) throws FileNotFoundException {

        boolean first = true;

        try (Scanner sc = new Scanner(new File("test.fasta"))) {
            while (sc.hasNextLine()) {
                String line = sc.nextLine().trim();
                if (line.charAt(0) == '>') {
                    if (first)
                        first = false;
                    else
                        System.out.println();
                    System.out.printf("%s: ", line.substring(1));
                } else {
                    System.out.print(line);
                }
            }
        }
        System.out.println();
    }
}
