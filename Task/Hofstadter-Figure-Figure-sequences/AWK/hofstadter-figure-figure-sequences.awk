# Hofstadter Figure-Figure sequences
#
#    R(1) = 1; S(1) = 2;
#    R(n) = R(n-1) + S(n-1), n > 1
#    S(n) is the values not in R(n)

BEGIN {

    # start with the first two values of R and S to simplify finding S[n]:
    R[ 1 ] = 1;
    R[ 2 ] = 3;
    S[ 1 ] = 2;
    S[ 2 ] = 4;
    # maximum n we currently have of R and S
    rMax   = 2;
    sMax   = 2;

    # calculate and show the first 10 values of R:
    printf( "R[1..10]:" );
    for( n = 1; n < 11; n ++ )
    {
        printf( " %d", ffr( n ) );
    }
    printf( "\n" );
    # check that R[1..40] and S[1..960] contain the numbers 1..1000 once each
    # add the values of R[ 1..40 ] to the set V
    for( n = 1; n <= 40; n ++ )
    {
        V[ ffr( n ) ] ++;
    }
    # add the values of S[ 1..960 ] to the set V
    for( n = 1; n <= 960; n ++ )
    {
        V[ ffs( n ) ] ++;
    }
    # check all numbers are present and not duplicated
    ok = 1;
    for( n = 1; n <= 1000; n ++ )
    {
        if( ! ( n in V ) )
        {
            printf( "%d not present in R[1..40], S[1..960]\n", n );
            ok = 0;
        }
        else if( V[ n ] != 1 )
        {
            printf( "%d occurs %d times in R[1..40], S[1..960]\n", n, V[ n ] );
            ok = 0;
        }
    }
    if( ok )
    {
        printf( "R[1..40] and S[1..960] uniquely contain all 1..1000\n" );
    }

} # BEGIN

function ffr( n )
{
    # calculate R[n]
    if( ! ( n in R ) )
    {
        # we haven't calculated R[ n ] yet
        R[ n ]  = ffs( n - 1 );
        R[ n ] += ffr( n - 1 );
    }
return R[ n ];
} # ffr

function ffs( n )
{
    # calculate S[n]
    if( ! ( n in S ) )
    {
        # starting at the highest known R, calculate the next one and fill in the S values
        # continuing until we have enough S values
        do
        {
            R[ rMax + 1 ] = R[ rMax ] + S[ rMax ];
            for( sValue = R[ rMax ] + 1; sValue < R[ rMax + 1 ]; sValue ++ )
            {
                S[ sMax ++ ] = sValue;
            }
            rMax ++;
        }
        while( sMax < n );
    }
return S[ n ];
} # ffs
