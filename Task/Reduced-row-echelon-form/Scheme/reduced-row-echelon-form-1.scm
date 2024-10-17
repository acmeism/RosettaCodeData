(define (reduced-row-echelon-form matrix)
  (define (clean-down matrix from-row column)
    (cons (car matrix)
          (if (zero? from-row)
              (map (lambda (row)
                     (map -
                          row
                          (map (lambda (element)
                                 (/ (* element (list-ref row column))
                                    (list-ref (car matrix) column)))
                               (car matrix))))
                   (cdr matrix))
              (clean-down (cdr matrix) (- from-row 1) column))))
  (define (clean-up matrix until-row column)
    (if (zero? until-row)
        matrix
        (cons (map -
                   (car matrix)
                   (map (lambda (element)
                          (/ (* element (list-ref (car matrix) column))
                             (list-ref (list-ref matrix until-row) column)))
                        (list-ref matrix until-row)))
              (clean-up (cdr matrix) (- until-row 1) column))))
  (define (normalise matrix row with-column)
    (if (zero? row)
        (cons (map (lambda (element)
                     (/ element (list-ref (car matrix) with-column)))
                   (car matrix))
              (cdr matrix))
        (cons (car matrix) (normalise (cdr matrix) (- row 1) with-column))))
  (define (repeat procedure matrix indices)
    (if (null? indices)
        matrix
        (repeat procedure
                (procedure matrix (car indices) (car indices))
                (cdr indices))))
  (define (iota start stop)
    (if (> start stop)
        (list)
        (cons start (iota (+ start 1) stop))))
  (let ((indices (iota 0 (- (length matrix) 1))))
    (repeat normalise
            (repeat clean-up
                    (repeat clean-down
                            matrix
                            indices)
                    indices)
            indices)))
