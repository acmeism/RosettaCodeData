# Find Mian-Chowla numbers: an
#                    where: ai = 1,
#                      and: an = smallest integer such that ai + aj is unique
#                                            for all i, j in 1 .. n && i <= j
#
BEGIN \
{

    FALSE      = 0;
    TRUE       = 1;

    mcCount    = 1;

    for( i = 1; mcCount <= 100; i ++ )
    {
        # assume i will be part of the sequence
        mc[ mcCount ] = i;
        # check the sums
        isUnique = TRUE;
        for( mcPos = 1; mcPos <= mcCount && isUnique; mcPos ++ )
        {
            isUnique = ! ( ( i + mc[ mcPos ] ) in isSum );
        } # for j
        if( isUnique )
        {
            # i is a sequence element - store the sums
            for( k = 1; k <= mcCount; k ++ )
            {
                isSum[ i + mc[ k ] ] = TRUE;
            } # for k
            mcCount ++;
        } # if isUnique
    } # for i
    # print the sequence
    printf( "Mian Chowla sequence elements 1..30:\n" );
    for( i = 1; i <= 30; i ++ )
    {
        printf( " %d", mc[ i ] );
    } # for i
    printf( "\n" );
    printf( "Mian Chowla sequence elements 91..100:\n" );
    for( i = 91; i <= 100; i ++ )
    {
        printf( " %d", mc[ i ] );
    } # for i
    printf( "\n" );

} # BEGIN
