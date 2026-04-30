(import (srfi 231))  ;; intervals and arrays
(import (srfi 27))   ;; random number generation

(define make-direction cons)
(define direction-r car)
(define direction-c cdr)

(define (random-direction)
  (let* ((r (- (random-integer 3) 1))  ;; -1, 0, or 1
         (c (- (random-integer 3) 1))) ;; -1, 0, or 1
    (if (and (zero? r) (zero? c))
        ;; we need a nonzero direction
        (random-direction)
        (make-direction r c))))

(define (brownian-tree rows columns points)
  (let* ((D
          ;; The domain of the result bit-map
          (make-interval (vector rows columns)))
         (E
          ;; A bit-map of zeros extending D, with a one extra row
          ;; and column of zeros above and below, left and right of D
          (array-copy! (make-array (interval-dilate D '#(-1 -1) '#(1 1))
                                   (lambda args 0))
                       u1-storage-class
                       #t))  ;; mutable
         (B
          ;; The bit-map where we place dots, extracted from the
          ;; center of the extended bit-map
          (array-extract E D))
         (Ns
          ;; views of the extended bit-map E that give the
          ;; eight neighbors of bits in B via translation
          (map (lambda (translate)
                 (array-extract (array-translate E translate) D))
               '(#( 1 0) #(0  1) #(-1  0) #(0 -1)
                 #(-1 1) #(1 -1) #(-1 -1) #(1  1))))
         (B_ (array-getter B))        ;; gets values of B
         (B! (array-setter B))        ;; sets values of B
         (Ns_ (map array-getter Ns))) ;; gets values of all the neighbors
    ;; Set the seed bit
    (B! 1 (random-integer rows) (random-integer columns))
    (let loop1 ((p 0))
      (if (= p points)
          B
          (let* ((r (random-integer rows))
                 (c (random-integer columns)))
            (if (positive? (B_ r c))
                ;; already a bit there, loop without incrementing
                ;; the number of placed points
                (loop1 p)
                (let loop2 ((r r)
                            (c c))
                  (if (any (lambda (g) (positive? (g r c))) Ns_)
                      ;; at least one of the neighbors is 1
                      (begin
                        (B! 1 r c)        ;; set the bit to 1
                        (loop1 (+ p 1)))  ;; increment number of placed points
                      (let* ((direction (random-direction))
                             (r (+ r (direction-r direction)))
                             (c (+ c (direction-c direction))))
                        (if (and (< -1 r rows) (< -1 c columns))
                            ;; point remains in the domain
                            (loop2 r c)
                            ;; walked outside the domain, loop without
                            ;; incrementing the number of placed points.
                            (loop1 p)))))))))))

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

(write-pbm (brownian-tree 320 640 20000)
           "brownian-tree-320-640-20000.pbm")
