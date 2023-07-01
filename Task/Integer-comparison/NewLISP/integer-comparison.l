(print "Please enter the first number: ")
(set 'A (int (read-line)))
(print "Please enter the second number: ")
(set 'B (int (read-line)))
(println
"The first one is "
    (cond
        ((> A B) "greater than")
        ((= A B) "equal to")
        (true "less than"))
" the second.")
