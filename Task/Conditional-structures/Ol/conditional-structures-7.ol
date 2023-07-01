(define smart (case-lambda
   ((x)
      (print x ", -, -"))
   ((x y)
      (print x ", " y ", -"))
   ((x y z)
      (print x ", " y ", " z))))
(smart 1)     ; ==> 1, -, -
(smart 1 2)   ; ==> 1, 2, -
(smart 1 2 3) ; ==> 1, 2, 3
