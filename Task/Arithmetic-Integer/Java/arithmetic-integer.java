import java.util.Scanner;

public class IntegerArithmetic {
    public static void main(String[] args) {
        // Get the 2 numbers from command line arguments
        Scanner sc = new Scanner(System.in);
        int a = sc.nextInt();
        int b = sc.nextInt();

        int sum = a + b;        // The result of adding 'a' and 'b' (Note: integer addition is discouraged in print statements due to confusion with string concatenation)
        int difference = a - b; // The result of subtracting 'b' from 'a'
        int product = a * b;    // The result of multiplying 'a' and 'b'
        int division = a / b;   // The result of dividing 'a' by 'b' (Note: 'division' does not contain the fractional result)
        int remainder = a % b;  // The remainder of dividing 'a' by 'b'

        System.out.println("a + b = " + sum);
        System.out.println("a - b = " + difference);
        System.out.println("a * b = " + product);
        System.out.println("quotient of a / b = " + division);   // truncates towards 0
        System.out.println("remainder of a / b = " + remainder);   // same sign as first operand
    }
}
