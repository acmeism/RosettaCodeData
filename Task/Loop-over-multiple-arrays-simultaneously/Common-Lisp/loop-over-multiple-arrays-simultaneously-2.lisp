  (loop for x in '("a" "b" "c")
        for y in '(a b c)
        for z in '(1 2 3)
        do (format t "~a~a~a~%" x y z))
