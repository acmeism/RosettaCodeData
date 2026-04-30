(import srfi/231)

(define (bit-Kronecker-product A B)
  ;; Assumes that A and B are specialized arrays with u1-storage-class,
  ;; i.e., that each array element is zero or one.
  (array-block! (array-map (lambda (a) (array-map (lambda (b) (* a b)) B)) A)
                u1-storage-class))

(define (bit-Kronecker-power A n)
  ;; Assumes n >= 1
  (do ((i 1 (+ i 1))
       (result A (bit-Kronecker-product A result)))
      ((= i n) result)))

(define (write-pbm array file)
  (with-output-to-file file
    (lambda ()
      (let* ((domain  (array-domain array))
             (rows    (interval-width domain 0))
             (columns (interval-width domain 1)))
        (display "P1") (newline)
        (display columns) (display " ") (display rows) (newline)
        (array-for-each (let ((next-pixel-in-line 1))
                          (lambda (p)
                            (write p)
                            (if (zero? (modulo next-pixel-in-line 64)) (newline))
                            (set! next-pixel-in-line (+ 1 next-pixel-in-line))))
                        array)))))

(write-pbm
 (bit-Kronecker-power (list*->array 2 '((0 1 0)
                                        (1 1 1)
                                        (0 1 0))
                                    u1-storage-class)
                      5)
 "vicsek-5.pbm")

(write-pbm
 (bit-Kronecker-power (list*->array 2 '((1 1 1)
                                        (1 0 1)
                                        (1 1 1))
                                    u1-storage-class)
                  5)
 "sierpinski-5.pbm")
