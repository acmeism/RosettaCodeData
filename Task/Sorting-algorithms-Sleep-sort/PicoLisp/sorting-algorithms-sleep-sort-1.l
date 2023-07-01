(de sleepSort (Lst)
   (make
      (for (I . N) Lst
         (task (- I) (* N 100)  N N  I I
            (link N)
            (pop 'Lst)
            (task (- I)) ) )
      (wait NIL (not Lst)) ) )
