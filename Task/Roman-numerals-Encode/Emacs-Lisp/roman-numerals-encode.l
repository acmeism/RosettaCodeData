(defun ar2ro (AN)
  "translate from arabic number AN to roman number,
   ar2ro(1666) returns (M D C L X V I)"
  (cond
   ((>= AN 1000) (cons 'M (ar2ro (- AN 1000))))
   ((>= AN 900) (cons 'C (cons 'M (ar2ro (-AN 900)))))
   ((>= AN 500) (cons 'D (ar2ro (- AN 500))))
   ((>= AN 400) (cons 'C (cons 'D (ar2ro (- AN 400)))))
   ((>= AN 100) (cons 'C (ar2ro (- AN 100))))
   ((>= AN 90) (cons 'X (cons 'C (ar2ro (- AN 90)))))
   ((>= AN 50) (cons 'L (ar2ro (- AN 50))))
   ((>= AN 40) (cons 'X (cons 'L (ar2ro (- AN 40)))))
   ((>= AN 10) (cons 'X (ar2ro (- AN 10))))
   ((>= AN 5) (cons 'V (ar2ro (- AN 5))))
   ((>= AN 4) (cons 'I (cons 'V (ar2ro (- AN 4)))))
   ((>= AN 1) (cons 'I (ar2ro (- AN 1))))
   ((= AN 0) nil)))
