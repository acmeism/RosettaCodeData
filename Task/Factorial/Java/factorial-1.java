package programas;

import java.math.BigInteger;
import java.util.InputMismatchException;
import java.util.Scanner;

public class IterativeFactorial {

  public BigInteger factorial(BigInteger n) {
    if ( n == null ) {
      throw new IllegalArgumentException();
    }
    else if ( n.signum() == - 1 ) {
      // negative
      throw new IllegalArgumentException("Argument must be a non-negative integer");
    }
    else {
      BigInteger factorial = BigInteger.ONE;
      for ( BigInteger i = BigInteger.ONE; i.compareTo(n) < 1; i = i.add(BigInteger.ONE) ) {
        factorial = factorial.multiply(i);
      }
      return factorial;
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
        result = new IterativeFactorial().factorial(number);
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
