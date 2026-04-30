#lang racket

(require racket/format)

; Matrix structure
(struct matrix (data rows cols) #:transparent)

; Constructor
(define (new-matrix data)
  (let ([rows (length data)]
        [cols (if (null? data) 0 (length (car data)))])
    (matrix data rows cols)))

; Getters
(define (get-rows m) (matrix-rows m))
(define (get-cols m) (matrix-cols m))

; Validation functions
(define (validate-dimensions m1 m2)
  (unless (and (= (get-rows m1) (get-rows m2))
               (= (get-cols m1) (get-cols m2)))
    (error "Matrices must have the same dimensions.")))

(define (validate-multiplication m1 m2)
  (unless (= (get-cols m1) (get-rows m2))
    (error "Cannot multiply these matrices.")))

(define (validate-square-power-of-two m)
  (let ([rows (get-rows m)]
        [cols (get-cols m)])
    (unless (= rows cols)
      (error "Matrix must be square."))
    (when (or (= rows 0) (not (= (bitwise-and rows (- rows 1)) 0)))
      (error "Size of matrix must be a power of two."))))

; Helper functions for matrix operations
(define (add-elements row1 row2)
  (map + row1 row2))

(define (subtract-elements row1 row2)
  (map - row1 row2))

(define (add-rows data1 data2)
  (map add-elements data1 data2))

(define (subtract-rows data1 data2)
  (map subtract-elements data1 data2))

; Matrix operations
(define (matrix-add m1 m2)
  (validate-dimensions m1 m2)
  (let ([data1 (matrix-data m1)]
        [data2 (matrix-data m2)])
    (new-matrix (add-rows data1 data2))))

(define (matrix-subtract m1 m2)
  (validate-dimensions m1 m2)
  (let ([data1 (matrix-data m1)]
        [data2 (matrix-data m2)])
    (new-matrix (subtract-rows data1 data2))))

; Get column from matrix data
(define (get-column data col-index)
  (map (lambda (row) (list-ref row col-index)) data))

; Dot product of two lists
(define (dot-product list1 list2)
  (apply + (map * list1 list2)))

; Multiply a row with entire matrix
(define (multiply-row-with-matrix row data2 cols2)
  (map (lambda (j) (dot-product row (get-column data2 j)))
       (range cols2)))

; Multiply rows
(define (multiply-rows data1 data2 cols2)
  (map (lambda (row) (multiply-row-with-matrix row data2 cols2))
       data1))

(define (matrix-multiply m1 m2)
  (validate-multiplication m1 m2)
  (let ([data1 (matrix-data m1)]
        [data2 (matrix-data m2)]
        [cols2 (get-cols m2)])
    (new-matrix (multiply-rows data1 data2 cols2))))

; String formatting functions
(define (format-element e)
  (~a e))

(define (format-row row)
  (string-append "[" (string-join (map format-element row) ", ") "]"))

(define (matrix-to-string m)
  (let ([data (matrix-data m)])
    (string-append (string-join (map format-row data) "\n") "\n")))

(define (format-element-with-precision e precision)
  (let* ([pow (expt 10.0 precision)]
         [rounded (/ (round (* e pow)) pow)]
         [formatted (~r rounded #:precision precision)]
         [zero-check (if (= precision 0)
                        "0"
                        (string-append "0." (make-string precision #\0)))])
    ; Handle negative zero
    (if (and (string-prefix? formatted "-")
             (string=? (substring formatted 1) zero-check))
        zero-check
        formatted)))

(define (format-row-with-precision row precision)
  (string-append "["
                 (string-join (map (lambda (e) (format-element-with-precision e precision)) row) ", ")
                 "]"))

(define (matrix-to-string-with-precision m precision)
  (let ([data (matrix-data m)])
    (string-append (string-join (map (lambda (row) (format-row-with-precision row precision)) data) "\n") "\n")))

; Strassen multiplication helper functions
(define (to-quarters m)
  (let* ([rows (get-rows m)]
         [r (quotient rows 2)]
         [data (matrix-data m)]
         [top-half (take data r)]
         [bottom-half (drop data r)])
    (list
     ; Q0: top-left
     (new-matrix (map (lambda (row) (take row r)) top-half))
     ; Q1: top-right
     (new-matrix (map (lambda (row) (drop row r)) top-half))
     ; Q2: bottom-left
     (new-matrix (map (lambda (row) (take row r)) bottom-half))
     ; Q3: bottom-right
     (new-matrix (map (lambda (row) (drop row r)) bottom-half)))))

(define (from-quarters quarters)
  (let ([q0 (first quarters)]
        [q1 (second quarters)]
        [q2 (third quarters)]
        [q3 (fourth quarters)])
    (let ([q0-data (matrix-data q0)]
          [q1-data (matrix-data q1)]
          [q2-data (matrix-data q2)]
          [q3-data (matrix-data q3)])
      (let ([top-half (map append q0-data q1-data)]
            [bottom-half (map append q2-data q3-data)])
        (new-matrix (append top-half bottom-half))))))

(define (strassen-impl m1 m2)
  (if (= (get-rows m1) 1)
      (matrix-multiply m1 m2)
      (let ([quarters-a (to-quarters m1)]
            [quarters-b (to-quarters m2)])
        (let ([a11 (first quarters-a)]
              [a12 (second quarters-a)]
              [a21 (third quarters-a)]
              [a22 (fourth quarters-a)]
              [b11 (first quarters-b)]
              [b12 (second quarters-b)]
              [b21 (third quarters-b)]
              [b22 (fourth quarters-b)])
          ; Calculate the 7 products according to Strassen's algorithm
          (let ([p1 (strassen-impl a11 (matrix-subtract b12 b22))]
                [p2 (strassen-impl (matrix-add a11 a12) b22)]
                [p3 (strassen-impl (matrix-add a21 a22) b11)]
                [p4 (strassen-impl a22 (matrix-subtract b21 b11))]
                [p5 (strassen-impl (matrix-add a11 a22) (matrix-add b11 b22))]
                [p6 (strassen-impl (matrix-subtract a12 a22) (matrix-add b21 b22))]
                [p7 (strassen-impl (matrix-subtract a11 a21) (matrix-add b11 b12))])
            ; Calculate result quarters
            (let ([c11 (matrix-add (matrix-subtract (matrix-add p5 p4) p2) p6)]
                  [c12 (matrix-add p1 p2)]
                  [c21 (matrix-add p3 p4)]
                  [c22 (matrix-subtract (matrix-subtract (matrix-add p5 p1) p3) p7)])
              (from-quarters (list c11 c12 c21 c22))))))))

(define (matrix-strassen m1 m2)
  (validate-square-power-of-two m1)
  (validate-square-power-of-two m2)
  (unless (and (= (get-rows m1) (get-rows m2))
               (= (get-cols m1) (get-cols m2)))
    (error "Matrices must be square and of equal size for Strassen multiplication."))
  (strassen-impl m1 m2))

; Main function for testing
(define (main)
  (let* ([a-data '((1.0 2.0) (3.0 4.0))]
         [a (new-matrix a-data)]
         [b-data '((5.0 6.0) (7.0 8.0))]
         [b (new-matrix b-data)]
         [c-data '((1.0 1.0 1.0 1.0) (2.0 4.0 8.0 16.0) (3.0 9.0 27.0 81.0) (4.0 16.0 64.0 256.0))]
         [c (new-matrix c-data)]
         [d-data `((4.0 -3.0 ,(/ 4.0 3.0) ,(/ -1.0 4.0))
                   (,(/ -13.0 3.0) ,(/ 19.0 4.0) ,(/ -7.0 3.0) ,(/ 11.0 24.0))
                   (1.5 -2.0 ,(/ 7.0 6.0) -0.25)
                   (,(/ -1.0 6.0) 0.25 ,(/ -1.0 6.0) ,(/ 1.0 24.0)))]
         [d (new-matrix d-data)]
         [e-data '((1.0 2.0 3.0 4.0) (5.0 6.0 7.0 8.0) (9.0 10.0 11.0 12.0) (13.0 14.0 15.0 16.0))]
         [e (new-matrix e-data)]
         [f-data '((1.0 0.0 0.0 0.0) (0.0 1.0 0.0 0.0) (0.0 0.0 1.0 0.0) (0.0 0.0 0.0 1.0))]
         [f (new-matrix f-data)])

    (displayln "Using 'normal' matrix multiplication:")
    (printf "  a * b = ~a" (matrix-to-string (matrix-multiply a b)))
    (printf "  c * d = ~a" (matrix-to-string-with-precision (matrix-multiply c d) 6))
    (printf "  e * f = ~a" (matrix-to-string (matrix-multiply e f)))

    (displayln "\nUsing 'Strassen' matrix multiplication:")
    (printf "  a * b = ~a" (matrix-to-string (matrix-strassen a b)))
    (printf "  c * d = ~a" (matrix-to-string-with-precision (matrix-strassen c d) 6))
    (printf "  e * f = ~a" (matrix-to-string (matrix-strassen e f)))))

; Export functions for use as a module
(provide new-matrix matrix? get-rows get-cols
         matrix-add matrix-subtract matrix-multiply matrix-strassen
         matrix-to-string matrix-to-string-with-precision main)

; Run the main function if this file is executed directly
(main)
