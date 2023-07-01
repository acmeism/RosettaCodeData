; Return the first row-count rows of Faulhaber's Triangle as a vector of vectors.
(define faulhabers-triangle
  (lambda (row-count)
    ; Calculate and store the value of the first column of a row.
    ; The value is one minus the sum of all the rest of the columns.
    (define calc-store-first!
      (lambda (row)
        (vector-set! row 0
          (do ((col-inx 1 (1+ col-inx))
               (col-sum 0 (+ col-sum (vector-ref row col-inx))))
              ((>= col-inx (vector-length row)) (- 1 col-sum))))))
    ; Generate the Faulhaber's Triangle one row at a time.
    ; The element at row i >= 0, column j >= 1 (both 0-based) is the product
    ; of the element at i - 1, j - 1 and the fraction ( i / ( j + 1 ) ).
    ; The element at column 0 is one minus the sum of all the rest of the columns.
    (let ((tri (make-vector row-count)))
      (do ((row-inx 0 (1+ row-inx)))
          ((>= row-inx row-count) tri)
        (let ((row (make-vector (1+ row-inx))))
          (vector-set! tri row-inx row)
          (do ((col-inx 1 (1+ col-inx)))
              ((>= col-inx (vector-length row)))
            (vector-set! row col-inx
              (* (vector-ref (vector-ref tri (1- row-inx)) (1- col-inx))
                 (/ row-inx (1+ col-inx)))))
          (calc-store-first! row))))))

; Convert elements of a vector to a string for display.
(define vector->string
  (lambda (vec)
    (do ((inx 0 (1+ inx))
         (str "" (string-append str (format "~7@a" (vector-ref vec inx)))))
        ((>= inx (vector-length vec)) str))))

; Display a Faulhaber's Triangle.
(define faulhabers-triangle-display
  (lambda (tri)
    (do ((inx 0 (1+ inx)))
        ((>= inx (vector-length tri)))
      (printf "~a~%" (vector->string (vector-ref tri inx))))))

; Task..
(let ((row-count 10))
  (printf "The first ~a rows of Faulhaber's Triangle..~%" row-count)
  (faulhabers-triangle-display (faulhabers-triangle row-count)))
(newline)
(let ((power 17)
      (sum-to 1000))
  (printf "Sum over k=1..~a of k^~a using Faulhaber's Triangle..~%" sum-to power)
  (let* ((tri (faulhabers-triangle (1+ power)))
         (coefs (vector-ref tri power)))
    (printf "~a~%" (do ((inx 0 (1+ inx))
                        (term-expt sum-to (* term-expt sum-to))
                        (sum 0 (+ sum (* (vector-ref coefs inx) term-expt))))
                       ((>= inx (vector-length coefs)) sum)))))
