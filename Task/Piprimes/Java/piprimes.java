public final class PiPrimes {

   public static void main(String[] args) {
      int primePi = 0;
      int n = 1;
      while ( primePi < 22 ) {
         System.out.print(String.format("%2d%s", primePi, ( n % 10 == 0 ) ? "\n" : " " ));
          n += 1;
         if ( isPrime(n) ) {
            primePi += 1;
         }
      }
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
