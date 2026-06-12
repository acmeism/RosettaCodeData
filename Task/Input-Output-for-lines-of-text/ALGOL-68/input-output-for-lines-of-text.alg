# outputs line plus a newline                                #
PROC show line = ( STRING line )VOID:
    print( ( line, newline ) );

# copy the lines with an loop with an anonymous loop counter #
# as the loop limit is evaluated only once, we can read the  #
# number of lines in the "TO" part                           #
TO ( INT n; read( ( n, newline ) ); n )
DO
    show line( ( STRING line; read( ( line, newline ) ); line ) )
OD
