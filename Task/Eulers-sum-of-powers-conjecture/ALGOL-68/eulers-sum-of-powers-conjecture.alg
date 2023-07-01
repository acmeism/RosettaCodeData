# max number will be the highest integer we will consider                    #
INT max number = 250;

# Construct a table of the fifth powers of 1 : max number                    #
[ max number ]LONG INT fifth;
FOR i TO max number DO
    LONG INT i2 =  i * i;
    fifth[ i ] := i2 * i2 * i
OD;

# find the first a, b, c, d, e such that a^5 + b^5 + c^5 + d^5 = e^5         #
# as the fifth powers are in order, we can use a binary search to determine  #
# whether the value is in the table                                          #
BOOL found := FALSE;
FOR a TO max number WHILE NOT found DO
    FOR b FROM a TO max number WHILE NOT found DO
        FOR c FROM b TO max number WHILE NOT found DO
            FOR d FROM c TO max number WHILE NOT found DO
                LONG INT sum   = fifth[a] + fifth[b] + fifth[c] + fifth[d];
                INT      low  := d;
                INT      high := max number;
                WHILE low < high
                  AND NOT found
                DO
                    INT e := ( low + high ) OVER 2;
                    IF fifth[ e ] = sum
                    THEN
                        # the value at e is a fifth power                    #
                        found := TRUE;
                        print( ( ( whole( a, 0 ) + "^5 + " + whole( b, 0 ) + "^5 + "
                                 + whole( c, 0 ) + "^5 + " + whole( d, 0 ) + "^5 = "
                                 + whole( e, 0 ) + "^5"
                                 )
                               , newline
                               )
                             )
                    ELIF sum < fifth[ e ]
                    THEN high := e - 1
                    ELSE low  := e + 1
                    FI
                OD
            OD
        OD
    OD
OD
