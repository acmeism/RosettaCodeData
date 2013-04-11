(de sleepSort (Lst)
   (make
      (for N Lst
         (task (pipe (wait (* N 100))) N N
            (link N)
            (pop 'Lst)
            (task (close @)) ) )
      (wait NIL (not Lst)) ) )
