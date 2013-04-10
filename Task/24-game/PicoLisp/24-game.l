(de checkExpression (Lst Exe)
   (make
      (when (diff Lst (fish num? Exe))
         (link "Not all numbers used" ) )
      (when (diff (fish num? Exe) Lst)
         (link "Using wrong number(s)") )
      (when (diff (fish sym? Exe) '(+ - * /))
         (link "Using illegal operator(s)") ) ) )

(loop
   (setq Numbers (make (do 4 (link (rand 1 9)))))
   (prinl
      "Please enter a Lisp expression using (, ), +, -, *, / and "
      (glue ", " Numbers) )
   (prin "Or a single dot '.' to stop: ")
   (T (= "." (setq Reply (catch '(NIL) (in NIL (read)))))
      (bye) )
   (cond
      ((str? Reply)
         (prinl "-- Input error: " Reply) )
      ((checkExpression Numbers Reply)
         (prinl "-- Illegal Expression")
         (for S @
            (space 3)
            (prinl S) ) )
      ((str? (setq Result (catch '(NIL) (eval Reply))))
         (prinl "-- Evaluation error: " @) )
      ((= 24 Result)
         (prinl "++ Congratulations! Correct result :-)") )
      (T (prinl "Sorry, this gives " Result)) )
   (prinl) )
