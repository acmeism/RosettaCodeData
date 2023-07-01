(let Semordnilap
   (mapcon
      '((Lst)
         (when (member (reverse (car Lst)) (cdr Lst))
            (cons (pack (car Lst))) ) )
      (make (in "unixdict.txt" (while (line) (link @)))) )
   (println (length Semordnilap) (head 5 Semordnilap)) )
