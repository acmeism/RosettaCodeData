package programas;

import java.math.BigInteger;
import java.util.InputMismatchException;
import java.util.Scanner;

public class RecursiveFactorial {

  public BigInteger factorial(BigInteger n) {
    if ( n == null ) {
      throw new IllegalArgumentException();
    }

    else if ( n.equals(BigInteger.ZERO) ) {
      return BigInteger.ONE;
    }
    else if ( n.signum() == - 1 ) {
      // negative
      throw new IllegalArgumentException("Argument must be a non-negative integer");
    }
    else {
      return n.equals(BigInteger.ONE)
          ? BigInteger.ONE
          : factorial(n.subtract(BigInteger.ONE)).multiply(n);
    }
  }

  public static void main(String[] args) {
    Scanner scanner = new Scanner(System.in);
    BigInteger number, result;
    boolean error = false;
    System.out.println("FACTORIAL OF A NUMBER");
    do {
      System.out.println("Enter a number:");
      try {
        number = scanner.nextBigInteger();
        result = new RecursiveFactorial().factorial(number);
        error = false;
        System.out.println("Factorial of " + number + ": " + result);
      }
      catch ( InputMismatchException e ) {
        error = true;
        scanner.nextLine();
      }

      catch ( IllegalArgumentException e ) {
        error = true;
        scanner.nextLine();
      }
    }
    while ( error );
    scanner.close();

  }

}
