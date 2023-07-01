import java.util.Scanner;

public class GetInput {
    public static void main(String[] args) throws Exception {
        Scanner s = new Scanner(System.in);
        System.out.print("Enter a string: ");
        String str = s.nextLine();
        System.out.print("Enter an integer: ");
        int i = Integer.parseInt(s.next());
    }
}
