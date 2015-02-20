# Algol 68 has a standard operator: ODD which returns TRUE if it's integer #
# operand is odd and FALSE if it is even                                   #
# E.g.:                                                                    #

INT n;
print( ( "Enter an integer: " ) );
read( ( n ) );
print( ( whole( n, 0 ), " is ", IF ODD n THEN "odd" ELSE "even" FI, newline ) )
