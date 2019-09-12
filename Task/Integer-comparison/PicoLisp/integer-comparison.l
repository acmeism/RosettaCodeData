(prin "Please enter two values: ")

(in NIL  # Read from standard input
   (let (A (read)  B (read))
      (prinl
         "The first one is "
         (cond
            ((> A B) "greater than")
            ((= A B) "equal to")
            (T "less than") )
         " the second." ) ) )
