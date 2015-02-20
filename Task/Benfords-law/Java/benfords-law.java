import java.math.BigInteger;

public class Benford {
    private static interface NumberGenerator {
        BigInteger[] getNumbers();
    }

    private static class FibonacciGenerator implements NumberGenerator {
        public BigInteger[] getNumbers() {
            final BigInteger[] fib = new BigInteger[ 1000 ];
            fib[ 0 ] = fib[ 1 ] = BigInteger.ONE;
            for ( int i = 2; i < fib.length; i++ )
                fib[ i ] = fib[ i - 2 ].add( fib[ i - 1 ] );
            return fib;
        }
    }

    private final int[] firstDigits = new int[ 9 ];
    private final int   count;

    private Benford( final NumberGenerator ng ) {
        final BigInteger[] numbers = ng.getNumbers();
        count = numbers.length;
        for ( final BigInteger number : numbers )
            firstDigits[ Integer.valueOf( number.toString().substring( 0, 1 ) ) - 1 ]++;
    }

    public String toString() {
        final StringBuilder result = new StringBuilder();
        for ( int i = 0; i < firstDigits.length; i++ )
            result.append( i + 1 )
                .append( '\t' ).append( firstDigits[ i ] / ( double )count )
                .append( '\t' ).append( Math.log10( 1 + 1d / ( i + 1 ) ) )
                .append( '\n' );
        return result.toString();
    }

    public static void main( final String[] args ) {
        System.out.println( new Benford( new FibonacciGenerator() ) );
    }
}
