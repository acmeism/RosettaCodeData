class FizzBuzz {
  public static void main( String [] args ) {
    for( int i = 1 ; i <= 100 ; i++ ) {
      System.out.println( new String[]{ i+"", "Fizz", "Buzz", "FizzBuzz" }[ ( i%3==0?1:0 ) + ( i%5==0?2:0 ) ]);
    }
  }
}
