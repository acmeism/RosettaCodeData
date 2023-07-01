# returns the sum of the multiples of 3 and 5 below n #
PROC sum of multiples of 3 and 5 below = ( LONG LONG INT n )LONG LONG INT:
     BEGIN
        # calculate the sum of the multiples of 3 below n #
        LONG LONG INT multiples of  3 = ( n - 1 ) OVER  3;
        LONG LONG INT multiples of  5 = ( n - 1 ) OVER  5;
        LONG LONG INT multiples of 15 = ( n - 1 ) OVER 15;
        ( # twice the sum of multiples of  3 #
          (  3 * multiples of  3 * ( multiples of  3 + 1 ) )
          # plus twice the sum of multiples of  5 #
        + (  5 * multiples of  5 * ( multiples of  5 + 1 ) )
          # less twice the sum of multiples of 15 #
        - ( 15 * multiples of 15 * ( multiples of 15 + 1 ) )
        ) OVER 2
    END # sum of multiples of 3 and 5 below # ;

print( ( "Sum of multiples of 3 and 5 below 1000: "
       , whole( sum of multiples of 3 and 5 below( 1000 ), 0 )
       , newline
       )
     );
print( ( "Sum of multiples of 3 and 5 below 1e20: "
       , whole( sum of multiples of 3 and 5 below( 100 000 000 000 000 000 000 ), 0 )
       , newline
       )
     )
