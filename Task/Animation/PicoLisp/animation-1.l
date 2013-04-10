#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(prin "^[[?9h")  # Mouse reporting on

(setq Dir 1  Text (chop "Hello World! "))

(loop
   (prin (do Dir (rot Text)))
   (when (= "^[" (key 200))
      (key) (key)
      (when (= " " (key))  # Left button
         (setq Dir (if (= 1 Dir) 12 1)) )
      (key) (key) )
   (do (length Text) (prin "^H")) )
