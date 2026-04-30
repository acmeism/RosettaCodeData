(cl-loop for el in '(2 7 5) maximize el) ;=> 7
(cl-reduce #'max '(2 7 5)) ;=> 7
