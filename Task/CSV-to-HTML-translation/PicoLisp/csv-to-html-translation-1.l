(load "@lib/http.l")

(in "text.csv"
   (<table> 'myStyle NIL NIL
      (prinl)
      (while (split (line) ",")
         (<row> NIL (ht:Prin (pack (car @))) (ht:Prin (pack (cadr @))))
         (prinl) ) ) )
