import java.io.Console;

public class Main {
    public static void main(String[] args) {
        if (System.console() != null) {
            System.out.println("stdout is a terminal");
        } else {
            System.out.println("stdout is not a terminal");
        }
    }
}
