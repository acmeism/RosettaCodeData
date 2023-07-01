(de mousePosition ()
   (prog2
      (prin "^[[?9h")  # Mouse reporting on
      (and
         (= "^[" (key))
         (key 200)
         (key 200)
         (key)
         (cons
            (- (char (key)) 32)
            (- (char (key)) 32) ) )
      (prin "^[[?9l") ) )  # Mouse reporting off
