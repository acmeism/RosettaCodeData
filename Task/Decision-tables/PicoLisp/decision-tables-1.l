(de yes? (Cond)
   (out NIL (prin (car Cond) "? "))
   (in NIL
      (use Reply
         (loop
            (setq Reply (read))
            (T (member Reply '(T Y YES Yes y yes true 1))
               T )
            (T (member Reply '(NIL N NO No n no false 0)))
            (prinl "Please answer 'Yes' or 'No'") ) ) ) )
