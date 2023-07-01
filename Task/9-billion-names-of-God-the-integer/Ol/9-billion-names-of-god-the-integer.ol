(define (nine-billion-names row column)
   (cond
      ((<= row 0) 0)
      ((<= column 0) 0)
      ((< row column) 0)
      ((= row 1) 1)
      (else
         (let ((addend (nine-billion-names (- row 1) (- column 1)))
               (augend (nine-billion-names (- row column) column)))
	         (+ addend augend)))))

(define (print-row row)
   (for-each (lambda (x)
         (display (nine-billion-names row x))
         (display " "))
      (iota row 1)))

(define (print-triangle rows)
   (for-each (lambda (x)
         (print-row x)
         (print))
      (iota rows 1)))

(print-triangle 25)
