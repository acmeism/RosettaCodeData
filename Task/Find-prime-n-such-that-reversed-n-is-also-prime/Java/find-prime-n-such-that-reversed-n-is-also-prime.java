public final class FindPrimeNSuchThatReversedNIsAlsoPrime {

  public static void main(String[] args) {
    for ( int n = 2; n < 500; n++ ) {
      if ( isReversedPrime(n) ) {
        System.out.print(n + " ");
      }
    }
    System.out.println();
  }

  private static boolean isReversedPrime(int number) {
      if ( ! isPrime(number) ) {
        return false;
      }

      int reversed = 0;
      while ( number > 0 ) {
          reversed = reversed * 10 + number % 10;
          number /= 10;
      }
      return isPrime(reversed);
  }

  private static boolean isPrime(int number) {
      if ( number % 2 == 0 ) {
        return number == 2;
      }
      int k = 3;
      while ( k * k <= number ) {
        if ( number % k == 0 ) {
          return false;
        }
        k += 2;
      }
      return true;
  }

}
