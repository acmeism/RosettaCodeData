USING: combinators.short-circuit formatting kernel math
math.parser qw regexp sequences unicode ;
IN: rosetta-code.cusip

: cusip-check-digit ( seq -- n )
    but-last-slice [
        [ dup alpha? [ digit> ] [ "*@#" index 36 + ] if ] dip
        odd? [ 2 * ] when 10 /mod +
    ] map-index sum 10 mod 10 swap - 10 mod ;

: cusip? ( seq -- ? )
    {
        [ R/ [0-9A-Z*@#]+/ matches? ]
        [ [ last digit> ] [ cusip-check-digit ] bi = ]
    } 1&& ;

qw{ 037833100 17275R102 38259P508 594918104 68389X106 68389X105 }
[ dup cusip? "correct" "incorrect" ? "%s -> %s\n" printf ] each
