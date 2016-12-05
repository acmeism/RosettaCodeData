# determine whether the first few Hickerson numbers really are "near integers" #
# The Hickerson number n is defined by: h(n) = n! / ( 2 * ( (ln 2)^(n+1) ) )   #
#                                   so: h(1) = 1 / ( 2 * ( ( ln 2 ) ^ 2 )      #
#                                  and: h(n) = ( n / ln 2 ) * h(n-1)           #

# set the precision of LONG LONG numbers                                       #
PR precision 100 PR

# calculate the Hickerson numbers                                              #
LONG LONG REAL ln2 = long long ln( 2 );
[ 1 : 18 ]LONG LONG REAL h;

h[ 1 ] := 0.5 / ( ln2 * ln2 );
FOR n FROM 2 TO UPB h
DO
    h[ n ] := ( n * h[ n - 1 ] ) / ln2
OD;

# determine the first digit after the point in each h(n) - if it is 0 or 9     #
# the number is a "near integer"                                               #

FOR n TO UPB h
DO
    INT first decimal = SHORTEN SHORTEN ( ( ENTIER ( h[ n ] * 10 ) ) MOD 10 );
    print( ( whole( n, -4 )
           , " "
           , fixed( h[ n ], 40, 4 )
           , IF first decimal = 0 OR first decimal = 9
             THEN
                 "     a near integer"
             ELSE
                 " NOT a near integer"
             FI
           , newline
           )
        )
OD
