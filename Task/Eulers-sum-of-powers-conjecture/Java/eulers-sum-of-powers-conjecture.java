public class eulerSopConjecture
{

    static final int    MAX_NUMBER = 250;

    public static void main( String[] args )
    {
        boolean found = false;
        long[]  fifth = new long[ MAX_NUMBER ];

        for( int i = 1; i <= MAX_NUMBER; i ++ )
        {
            long i2 =  i * i;
            fifth[ i - 1 ] = i2 * i2 * i;
        } // for i

        for( int a = 0; a < MAX_NUMBER && ! found ; a ++ )
        {
            for( int b = a; b < MAX_NUMBER && ! found ; b ++ )
            {
                for( int c = b; c < MAX_NUMBER && ! found ; c ++ )
                {
                    for( int d = c; d < MAX_NUMBER && ! found ; d ++ )
                    {
                        long sum  = fifth[a] + fifth[b] + fifth[c] + fifth[d];
                        int  e = java.util.Arrays.binarySearch( fifth, sum );
                        found  = ( e >= 0 );
                        if( found )
                        {
                            // the value at e is a fifth power
                            System.out.print( (a+1) + "^5 + "
                                            + (b+1) + "^5 + "
                                            + (c+1) + "^5 + "
                                            + (d+1) + "^5 = "
                                            + (e+1) + "^5"
                                            );
                        } // if found;;
                    } // for d
                } // for c
            } // for b
        } // for a
    } // main

} // eulerSopConjecture
