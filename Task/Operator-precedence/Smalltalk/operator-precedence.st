5 + b negated.                 "same as 5 + (b negated); unary > binary"
a abs - b sqrt                 "same as (a abs) - (b sqrt); unary > binary"
a bitAnd:1+a abs.              "same as a bitAnd:(1+(a abs)); unary > binary > keyword"
(a bitAnd:1+a) bitOr:(b bitAnd:1+2 abs). "ditto"

"Beginners might be confused by:"
5 + a * b                        "same as (5 + a) * b; all binary; therefore left to right"
