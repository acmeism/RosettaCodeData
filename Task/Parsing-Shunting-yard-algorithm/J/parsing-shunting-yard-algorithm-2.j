   fulfill_requirement '3+4*2/(1-5)^2^3'
 3 4 2 * 1 5 - 2 3 ^ ^ / +

   shunt_yard_parse'3*)2+4)'
Check your parens!

   shunt_yard_parse'3*(2+4'
Check your other parens!

   algebra_to_rpn'1+x*(3+x)'
discarding invalid token x
discarding invalid token x
┌─┬─┬─┬─┬─┐
│1│3│+│*│+│
└─┴─┴─┴─┴─┘

   NB. Boxed form useful for evaluation
   algebra_to_rpn'0+666*(1+666*(2+666*(3)))'  NB. polynomial evaluation.
┌─┬───┬─┬───┬─┬───┬─┬─┬─┬─┬─┬─┬─┐
│0│666│1│666│2│666│3│*│+│*│+│*│+│
└─┴───┴─┴───┴─┴───┴─┴─┴─┴─┴─┴─┴─┘

   1 fulfill_requirement'3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3'
OUTPUT queue 3
OPERATOR pop
OUTPUT queue
OPERATOR stack +
OUTPUT queue 4
OPERATOR pop
OUTPUT queue
OPERATOR stack *
OUTPUT queue 2
OPERATOR pop *
OUTPUT queue *
OPERATOR stack /
OPERATOR stack (
OUTPUT queue 1
OPERATOR pop
OUTPUT queue
OPERATOR stack -
OUTPUT queue 5
OPERATOR pop -
OUTPUT queue -
OPERATOR pop (
OPERATOR pop
OUTPUT queue
OPERATOR stack ^
OUTPUT queue 2
OPERATOR pop
OUTPUT queue
OPERATOR stack ^
OUTPUT queue 3
OPERATOR pop ^ ^ / +
OUTPUT queue ^ ^ / +
 3 4 2 * 1 5 - 2 3 ^ ^ / +
