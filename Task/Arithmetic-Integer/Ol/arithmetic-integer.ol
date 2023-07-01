(define a 8)
(define b 12)

(print "(+ " a " " b ") => "    (+ a b))
(print "(- " a " " b ") => "    (- a b))
(print "(* " a " " b ") => "    (* a b))
(print "(/ " a " " b ") => "    (/ a b))

(print "(quotient " a " " b ") => "  (quot a b)) ; same as (quotient a b)
(print "(remainder " a " " b ") => " (rem  a b)) ; same as (remainder a b)
(print "(modulo " a " " b ") => "    (mod  a b)) ; same as (modulo a b)

(print "(expt " a " " b ") => " (expt a b))
(print "(gcd " a " " b ") => " (gcd a b))
(print "(lcm " a " " b ") => " (lcm a b))

; you can use more than two arguments for +,-,*,/ functions
(print (+ 1 3 5 7 9))
(print (- 1 3 5 7 9))
(print (* 1 3 5 7 9)) ; same as (1*3*5*7*9)
(print (/ 1 3 5 7 9)) ; same as (((1/3)/5)/7)/9
