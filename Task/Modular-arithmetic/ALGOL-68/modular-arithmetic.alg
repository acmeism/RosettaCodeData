# allow for large integers in Algol 68G #
PR precision 200 PR

# modular integer type #
MODE MODULARINT = STRUCT( LONG LONG INT v, INT modulus );

# modular integer + and * operators #
# where both operands are modular, they must have the same modulus #
OP +  = ( MODULARINT a,     b )MODULARINT: ( ( v OF a + v OF b ) MOD modulus OF a, modulus OF a );
OP +  = ( MODULARINT a, INT b )MODULARINT: ( ( v OF a + b      ) MOD modulus OF a, modulus OF a );
OP *  = ( MODULARINT a,     b )MODULARINT: ( ( v OF a * v OF b ) MOD modulus OF a, modulus OF a );
OP ** = ( MODULARINT a, INT b )MODULARINT: ( ( v OF a ** b     ) MOD modulus OF a, modulus OF a );

# f(x) function - can be applied to either LONG LONG INT or MODULARINT values #
# the result is always a LONG LONG INT #
PROC f = ( UNION( LONG LONG INT, MODULARINT ) x )LONG LONG INT:
    CASE x
      IN ( LONG LONG INT ix ):      ( ix**100 + ix + 1 )
       , ( MODULARINT    mx ): v OF ( mx**100 + mx + 1 )
    ESAC;

print( ( whole( f( MODULARINT( 10, 13 ) ), 0 ), newline ) )
