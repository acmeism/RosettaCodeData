USING: io kernel math math.functions math.parser ranges
sequences ;
IN: rosetta-code.fizz-buzz

PREDICATE: fizz < integer 3 divisor? ;
PREDICATE: buzz < integer 5 divisor? ;

INTERSECTION: fizzbuzz fizz buzz ;

GENERIC: fizzbuzz>string ( n -- str )

M: fizz fizzbuzz>string
    drop "Fizz" ;

M: buzz fizzbuzz>string
    drop "Buzz" ;

M: fizzbuzz fizzbuzz>string
    drop "FizzBuzz" ;

M: integer fizzbuzz>string
    number>string ;

MAIN: [ 1 100 [a..b] [ fizzbuzz>string print ] each ]
