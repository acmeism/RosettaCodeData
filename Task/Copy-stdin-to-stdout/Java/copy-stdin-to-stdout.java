import java.util.Scanner;

public class CopyStdinToStdout {

    public static void main(String[] args) {
        try (Scanner scanner = new Scanner(System.in);) {
            String s;
            while ( (s = scanner.nextLine()).compareTo("") != 0 ) {
                System.out.println(s);
            }
        }
    }

}
