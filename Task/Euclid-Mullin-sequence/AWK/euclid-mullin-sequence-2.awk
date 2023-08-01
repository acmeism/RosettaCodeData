# find elements of the Euclid-Mullin sequence: starting from 2,
# the next element is the smallest prime factor of 1 + the product
# of the previous elements
BEGIN {
    printf( "2" );
    product = 2;
    for( i = 2; i <= 8; i ++ )
    {
        nextV = product + 1;
        # find the first prime factor of nextV
        p = 3;
        found = 0;
        while( p * p <= nextV && ! ( found = nextV % p == 0 ) )
        {
            p += 2;
        }
        if( found )
        {
            nextV = p;
        }
        printf( " %d", nextV );
        product *= nextV
    }
}
