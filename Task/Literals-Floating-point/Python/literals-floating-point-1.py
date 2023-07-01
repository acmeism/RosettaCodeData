FLOAT
    :   '.' DIGITS (Exponent)?
    |   DIGITS '.' Exponent
    |   DIGITS ('.' (DIGITS (Exponent)?)? | Exponent)
    ;

DIGITS : ( '0' .. '9' )+ ;

Exponent
    :    ('e' | 'E') ( '+' | '-' )? DIGITS
    ;
