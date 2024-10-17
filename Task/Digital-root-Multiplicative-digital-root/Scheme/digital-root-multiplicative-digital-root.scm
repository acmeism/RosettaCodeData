; Convert an integer into a list of its digits.

(define integer->list
  (lambda (integer)
    (let loop ((list '()) (int integer))
      (if (< int 10)
        (cons int list)
        (loop (cons (remainder int 10) list) (quotient int 10))))))

; Return the product of the digits of an integer.

(define integer-product-digits
  (lambda (integer)
    (fold-left * 1 (integer->list integer))))

; Compute the multiplicative digital root and multiplicative persistence of an integer.
; Return as a cons of (mdr . mp).

(define mdr-mp
  (lambda (integer)
    (let loop ((int integer) (cnt 0))
      (if (< int 10)
        (cons int cnt)
        (loop (integer-product-digits int) (1+ cnt))))))

; Emit a table of integer, multiplicative digital root, and multiplicative persistence
; for the example integers given.  Example list ends with sequence A003001 from OEIS.

(printf "~16@a ~6@a ~6@a~%" "Integer" "Root" "Pers.")
(printf "~16@a ~6@a ~6@a~%" "===============" "======" "======")
(let rowloop ((intlist '(123321 7739 893 899998
                         0 10 25 39 77 679 6788 68889 2677889 26888999 3778888999 277777788888899)))
  (when (pair? intlist)
    (let* ((int (car intlist))
           (mm (mdr-mp int)))
      (printf "~16@a ~6@a ~6@a~%" int (car mm) (cdr mm))
      (rowloop (cdr intlist)))))

; Emit a table of multiplicative digital root versus the first five integers having that MDR.

(newline)
(printf "~5@a ~a~%" "Root" "First five integers with that root")
(printf "~5@a ~a~%" "====" "==================================")
(let ((mdrslsts (make-vector 10 '())))
  (do ((integer 0 (1+ integer)))
      ((>= (fold-left min 5 (vector->list (vector-map length mdrslsts))) 5))
    (let ((mdr (car (mdr-mp integer))))
      (when (< (length (vector-ref mdrslsts mdr)) 5)
        (vector-set! mdrslsts mdr (append (vector-ref mdrslsts mdr) (list integer))))))
  (do ((mdr 0 (1+ mdr)))
      ((>= mdr 10))
    (printf "~5@a" mdr)
    (for-each (lambda (int) (printf "~7@a" int)) (vector-ref mdrslsts mdr))
    (newline)))
