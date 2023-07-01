# Multiplicative Digital Roots

BEGIN {

    printMdrAndMp( 123321 );
    printMdrAndMp(   7739 );
    printMdrAndMp(    893 );
    printMdrAndMp( 899998 );

    tabulateMdr( 5 );

} # BEGIN

function printMdrAndMp( n )
{
    calculateMdrAndMp( n );
    printf( "%6d: MDR: %d, MP: %2d\n", n, MDR, MP );
} # printMdrAndMp

function calculateMdrAndMp( n,                     mdrStr, digit )
{

    MP  = 0;                     # global Multiplicative Persistence
    MDR = ( n < 0 ? -n : n );    # global Multiplicative Digital Root

    while( MDR > 9 )
    {
        MP ++;
        mdrStr = "" MDR;
        MDR    = 1;
        for( digit = 1; digit <= length( mdrStr ); digit ++ )
        {
            MDR *= ( substr( mdrStr, digit, 1 ) * 1 );
        } # for digit
    } # while MDR > 9

} # calculateMdrAndMp

function tabulateMdr( n,                  rqdValues, valueCount, value, pos )
{

    # generate a table of the first n numbers with each possible MDR

    rqdValues  = n * 10;
    valueCount = 0;

    for( value = 0; valueCount < rqdValues; value ++ )
    {
        calculateMdrAndMp( value );
        if( mdrCount[ MDR ] < n )
        {
            # still need another value with this MDR
            valueCount ++;
            mdrCount[ MDR ] ++;
            mdrValues[ MDR ":" mdrCount[ MDR ] ] = value;
        } # if mdrCount[ MDR ] < n
    } # for value

    # print the table

    printf( "MDR: [n0..n%d]\n", n - 1 );
    printf( "===  ========\n" );

    for( pos = 0; pos < 10; pos ++ )
    {
        printf( "%3d:", pos );
        separator = " [";
        for( value = 1; value <= n; value ++ )
        {
            printf( "%s%d", separator, mdrValues[ pos ":" value ] );
            separator = ", "
        } # for value
        printf( "]\n" );
    } # for pos

} # tabulateMdr
