#lang racket

;; Define a point structure
(struct point (x y) #:transparent)

;; Main function
(define (main)
  (define points (list (point 1 1) (point 2 4) (point 3 1) (point 4 5)))
  (display-polynomial (lagrange-interpolation points)))

;; Lagrange interpolation function
(define (lagrange-interpolation points)
  (define (create-poly i)
    (define base-poly '(1.0))
    (define poly
      (for/fold ([poly base-poly])
                ([j (in-range (length points))])
        (if (= i j)
            poly
            (multiply poly (list (- (point-x (list-ref points j))) 1.0)))))
    (define value (evaluate poly (point-x (list-ref points i))))
    (scalar-divide poly value))

  (define polys
    (for/list ([i (in-range (length points))])
      (create-poly i)))

  (define weighted-polys
    (for/list ([i (in-range (length points))])
      (scalar-multiply (list-ref polys i) (point-y (list-ref points i)))))

  (foldl add '(0.0) weighted-polys))

;; Add two polynomials
;; A list is used to represent a Polynomial
;; with its coefficients reversed compared to the standard mathematical notation.
;; For example, the polynomial 3x^2 + 2x + 1 is represented by the list (1 2 3).
(define (add p1 p2)
  (define len1 (length p1))
  (define len2 (length p2))
  (define max-len (max len1 len2))

  (define p1-padded (append p1 (make-list (- max-len len1) 0.0)))
  (define p2-padded (append p2 (make-list (- max-len len2) 0.0)))

  (map + p1-padded p2-padded))

;; Multiply two polynomials
(define (multiply p1 p2)
  (define len1 (length p1))
  (define len2 (length p2))
  (define result-len (+ len1 len2 -1))
  (define result (make-list result-len 0.0))

  (for*/fold ([res result])
             ([i (in-range len1)]
              [j (in-range len2)])
    (define idx (+ i j))
    (define val (* (list-ref p1 i) (list-ref p2 j)))
    (list-set res idx (+ (list-ref res idx) val))))

;; Scalar multiply a polynomial
(define (scalar-multiply poly scalar)
  (map (λ (x) (* x scalar)) poly))

;; Scalar divide a polynomial
(define (scalar-divide poly divisor)
  (scalar-multiply poly (/ 1.0 divisor)))

;; Evaluate a polynomial at point x
(define (evaluate poly x)
  (for/fold ([result 0.0])
            ([coef (reverse poly)])
    (+ (* result x) coef)))

;; Display a polynomial
(define (display-polynomial poly)
  (if (= (length poly) 1)
      (printf "~a\n" (~r (first poly) #:precision 5))
      (let ([degree (- (length poly) 1)])
        (let loop ([i degree]
                   [first? #t]
                   [result ""])
          (if (< i 0)
              (printf "~a\n" (if (string=? result "") "0" result))
              (let ([coef (list-ref poly i)])
                (if (= coef 0.0)
                    (loop (- i 1) first? result)
                    (let* ([abs-coef (abs coef)]
                           [sign (cond [(< coef 0.0) (if first? "-" " - ")]
                                       [(and (not first?) (>= coef 0.0)) " + "]
                                       [else ""])]
                           [coef-str (if (or (= abs-coef 1.0) (and (> i 0) (= abs-coef 1.0)))
                                        ""
                                        (~r abs-coef #:precision 5))]
                           [term (cond [(> i 1) (format "x^~a" i)]
                                       [(= i 1) "x"]
                                       [(= abs-coef 1.0) "1"]
                                       [else ""])]
                           [term-str (string-append sign coef-str term)])
                      (loop (- i 1) #f (string-append result term-str))))))))))

;; Run the main function
(main)
