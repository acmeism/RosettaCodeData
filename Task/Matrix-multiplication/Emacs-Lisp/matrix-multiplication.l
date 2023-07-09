(defvar M1 '((2 1 4)
             (0 1 1)))

(defvar M2 '(( 6  3 -1  0)
             ( 1  1  0  4)
             (-2  5  0  2)))

(seq-map (lambda (a1)
           (seq-map (lambda (a2) (apply #'+ (seq-mapn #'* a1 a2)))
                    (apply #'seq-mapn #'list M2)))
         M1)
