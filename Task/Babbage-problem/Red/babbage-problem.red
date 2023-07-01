Red []
number: 510 ;; starting number
;; repeat, until the last condition in the block is true
until [
 number: number + 2 ;; only even numbers can have even squares
 ;; The word modulo computes the non-negative remainder of the
 ;; first argument divided by the second argument.
 ;; **  =>  Returns a number raised to a given power (exponent)
  269696 = modulo (number ** 2) 1000000
]
?? number
