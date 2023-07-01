COMMENT text between pairs of words 'comment' in capitals are
        for the human reader's information and are ignored by the machine
COMMENT

COMMENT Define s to be the integer value 269 696              COMMENT
INT s = 269 696;

COMMENT Name a location in the machine's storage area that will be
        used to hold integer values.
        The value stored in the location will change during the
        calculations.
        Note, "*" is used to represent the multiplication operator.
              ":=" causes the location named to the left of ":=" to
                   assume the value computed by the expression to the right.
              "sqrt" computes an approximation to the square root
                     of the supplied parameter
              "MOD" is an operator that computes the modulus of its
                    left operand with respect to its right operand
              "ENTIER" is a unary operator that yields the largest
                      integer that is at most its operand.
COMMENT
INT v := ENTIER sqrt( s );

COMMENT the construct: WHILE...DO...OD repeatedly executes the
        instructions between DO and OD, the execution stops when
        the instructions between WHILE and DO yield the value FALSE.
COMMENT
WHILE ( v * v ) MOD 1 000 000 /= s DO v := v + 1 OD;

COMMENT print displays the values of its parameters
COMMENT
print( ( v, " when squared is: ", v * v, newline ) )
