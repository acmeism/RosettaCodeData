(define a 8)
(define b 12)

(print "(+ " a " " b ") => "    (+ a b))
(print "(- " a " " b ") => "    (- a b))
(print "(* " a " " b ") => "    (* a b))
(print "(/ " a " " b ") => "    (/ a b))

(print "(quotient " a " " b ") => "  (quot a b)) ; same as (quotient a b)
(print "(remainder " a " " b ") => " (rem  a b)) ; same as (remainder a b)
(print "(modulo " a " " b ") => "    (mod  a b)) ; same as (modulo a b)

(import (owl math-extra))
(print "(expt " a " " b ") => " (expt a b))
