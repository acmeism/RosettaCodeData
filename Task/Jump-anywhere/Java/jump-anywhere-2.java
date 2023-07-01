public class FizzBuzzThrower {
    public static void main( String [] args ) {
        for ( int i = 1; i <= 30; i++ ) {
            try {
                String message = "";
                if ( i % 3 == 0 ) message = "Fizz";
                if ( i % 5 == 0 ) message += "Buzz";
                if ( ! "".equals( message ) ) throw new RuntimeException( message );
                System.out.print( i );
            } catch ( final RuntimeException x ) {
                System.out.print( x.getMessage() );
            } finally {
                System.out.println();
            }
        }
    }
}
