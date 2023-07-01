(import (scheme base)
        (scheme cxr)
        (scheme write)
        (srfi 1))

;; utility method to find unique sum/product in given list
(define (unique-items lst key)
  (let ((all-items (map key lst)))
    (filter (lambda (i) (= 1 (count (lambda (p) (= p (key i)))
                                    all-items)))
            lst)))

;; list of all (x y x+y x*y) combinations with y > x
(define *xy-pairs*
  (apply append
         (map (lambda (i)
                (map (lambda (j)
                       (list i j (+ i j) (* i j)))
                     (iota (- 98 i) (+ 1 i))))
              (iota 96 2))))

;; S says "P does not know X and Y"
(define *products* ; get products which have multiple decompositions
  (let ((all-products (map fourth *xy-pairs*)))
    (filter (lambda (p) (> (count (lambda (i) (= i p)) all-products) 1))
            all-products)))

(define *fact-1* ; every x+y has x*y in *products*
  (filter (lambda (i)
            (every (lambda (p) (memq (fourth p) *products*))
                   (filter (lambda (p) (= (third i) (third p))) *xy-pairs*)))
          *xy-pairs*))

;; P says "Now I know X and Y"
(define *fact-2* ; find the unique X*Y
  (unique-items *fact-1* fourth))

;; S says "Now I also know X and Y"
(define *fact-3* ; find the unique X+Y
  (unique-items *fact-2* third))

(display (string-append "Initial pairs: " (number->string (length *xy-pairs*)) "\n"))
(display (string-append "After S: " (number->string (length *fact-1*)) "\n"))
(display (string-append "After P: " (number->string (length *fact-2*)) "\n"))
(display (string-append "After S: " (number->string (length *fact-3*)) "\n"))
(display (string-append "X: "
                        (number->string (caar *fact-3*))
                        " Y: "
                        (number->string (cadar *fact-3*))
                        "\n"))
