(de EBNF
   "expr  : term ( ( PLUS | MINUS )  term )* ;"
   "term  : factor ( ( MULT | DIV ) factor )* ;"
   "factor   : NUMBER ;" )

(for E EBNF
   (use (@S @E)
      (unless (and (match '(@S : @E ;) (str E)) (not (cdr @S)))
         (quit "Invalid EBNF" E) )
      (put (car @S) 'ebnf @E) ) )
