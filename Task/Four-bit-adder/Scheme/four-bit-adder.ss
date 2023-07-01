(import (scheme base)
        (scheme write)
        (srfi 60))      ;; for logical bits

;; Returns a list of bits: '(sum carry)
(define (half-adder a b)
  (list (bitwise-xor a b) (bitwise-and a b)))

;; Returns a list of bits: '(sum carry)
(define (full-adder a b c-in)
  (let* ((h1 (half-adder c-in a))
         (h2 (half-adder (car h1) b)))
    (list (car h2) (bitwise-ior (cadr h1) (cadr h2)))))

;; a and b are lists of 4 bits each
(define (four-bit-adder a b)
  (let* ((add-1 (full-adder (list-ref a 3) (list-ref b 3) 0))
         (add-2 (full-adder (list-ref a 2) (list-ref b 2) (list-ref add-1 1)))
         (add-3 (full-adder (list-ref a 1) (list-ref b 1) (list-ref add-2 1)))
         (add-4 (full-adder (list-ref a 0) (list-ref b 0) (list-ref add-3 1))))
    (list (list (car add-4) (car add-3) (car add-2) (car add-1))
          (cadr add-4))))

(define (show-eg a b)
  (display a) (display " + ") (display b) (display " = ")
  (display (four-bit-adder a b)) (newline))

(show-eg (list 0 0 0 0) (list 0 0 0 0))
(show-eg (list 0 0 0 0) (list 1 1 1 1))
(show-eg (list 1 1 1 1) (list 0 0 0 0))
(show-eg (list 0 1 0 1) (list 1 1 0 0))
(show-eg (list 1 1 1 1) (list 1 1 1 1))
(show-eg (list 1 0 1 0) (list 0 1 0 1))
