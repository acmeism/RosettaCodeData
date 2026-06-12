BEGIN \
{
    fCount     = 0;
    nextToShow = 500;
    for( i = 1; i <= 5000000; i ++ )
    {
        if( isForbidden( i ) )
        {
            fCount += 1;
            if( fCount <= 50 )
            {
                printf( " %3d%s", i, ( ( fCount % 10 == 0 ) ? "\n" : "" ) );
            }
        }
        if( i == nextToShow )
        {
            printf( "There are %8d Forbidden numbers up to %d\n", fCount, i );
            nextToShow *= 10;
        }
    }
}
function isForbidden( n,                                           m, p4 )
{
    m  = n;
    p4 = 1;
    while( m > 1 && m % 4 == 0 )
    {
        m   = int( m / 4 );
        p4 *= 4;
    }
return int( n / p4 ) % 8 == 7;
}
