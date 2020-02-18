$ ol
Welcome to Otus Lisp 2.1-2282-27a9b6c
type ',help' to help, ',quit' to end session.
> (define (f head tail mid)
     (fold string-append "" (list head mid mid tail)))
;; Defined f
> (f "Rosetta" "Code" ":")
"Rosetta::Code"
> ,quit
bye-bye :/
