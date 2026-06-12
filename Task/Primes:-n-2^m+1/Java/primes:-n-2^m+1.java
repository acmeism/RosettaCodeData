import java.math.BigInteger;
public class primesNx2ToMPlus1 // find primes of the form 1+n*2^m where m is
{                              // the lowest integer >= 0 such that 1+n*2^m is prime
    static final int maxM = 8000;   // maximum m we will consider
    public static void main( String[] args )
    {
        BigInteger nn = BigInteger.ZERO;
        for( int n = 1; n <= 400; n ++ )
        {
            int        m        = 0;
            boolean    found    = false;
            nn                  = nn.add( BigInteger.ONE );
            BigInteger nx2ToM   = nn;
            BigInteger p        = BigInteger.ZERO;
            while( ! found && m <= maxM )
            {
                p = nx2ToM.add( BigInteger.ONE );
                if( ! ( found = p.isProbablePrime( 10 ) ) )
                {
                    nx2ToM = nx2ToM.add( nx2ToM );
                    m     += 1;
                }
            }
            System.out.print( String.format( "%3d", n ) );
            if( ! found )
            {
                System.out.println( " not found" );
            }
            else
            {
                System.out.println( " " + String.format( "%6d", m ) + ": " + p.toString() );
            }
        }
    } // main
} // primesNx2ToMPlus1
