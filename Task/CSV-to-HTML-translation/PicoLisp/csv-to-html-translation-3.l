(load "@lib/http.l")

(in "text.csv"
   (when (split (line) ",")
      (<table> 'myStyle NIL (mapcar '((S) (list NIL (pack S))) @)
         (prinl)
         (while (split (line) ",")
            (<row> NIL (ht:Prin (pack (car @))) (ht:Prin (pack (cadr @))))
            (prinl) ) ) ) )
