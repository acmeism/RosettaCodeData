USING: eval prettyprint ;

<<

"IN: math.parser.private
USE: combinators
: @pos-digit-or-punc ( i number-parse n char -- n/f )
    {
        { 95 [ [ @pos-digit ] require-next-digit ] }   ! normally 44
        { 43 [ ->numerator ] }
        { 47 [ ->denominator ] }
        { 46 [ ->mantissa ] }
        [ [ @pos-digit ] or-exponent ]
    } case ; inline" eval( -- )

>>

3_333_333 .   ! 3333333
