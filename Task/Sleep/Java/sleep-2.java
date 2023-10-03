import java.util.InputMismatchException;
import java.util.Scanner;
import java.util.concurrent.TimeUnit;

public final class Sleep {
	
    public static void main(String[] args) {
        try {
        	System.out.println("Enter time to sleep in milliseconds:");
        	Scanner scanner = new Scanner(System.in);        	
            final int delay = scanner.nextInt();
            scanner.close();

            System.out.println("Sleeping...");
            TimeUnit.MILLISECONDS.sleep(delay);
            System.out.println("Awake!");
        } catch (InputMismatchException | InterruptedException exception) {
           exception.printStackTrace(System.err);;
        }
    }

}
