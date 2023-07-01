;; Owl Lisp, though a dialect of Scheme, has no true variables: it has
;; only value-bindings. We cannot use "make-parameter" to specify an
;; optional modulus. Instead let us introduce a new type for modular
;; integers.

(define (modular? x)
  ;; The new type is simply a pair of integers.
  (and (pair? x) (integer? (car x)) (integer? (cdr x))))

(define (enhanced-op op)
  (lambda (x y)
    (if (modular? x)
        (if (modular? y)
            (begin
              (unless (= (cdr x) (cdr y))
                (error "mismatched moduli"))
              (cons (floor-remainder (op (car x) (car y)) (cdr x))
                    (cdr x)))
            (cons (floor-remainder (op (car x) y) (cdr x))
                  (cdr x)))
        (if (modular? y)
            (cons (floor-remainder (op x (car y)) (cdr y))
                  (cdr y))
            (op x y)))))

(define enhanced+ (enhanced-op +))
(define enhanced-expt (enhanced-op expt))

(define (f x)
  ;; Temporarily redefine + and expt so they can handle either regular
  ;; numbers or modular integers.
  (let ((+ enhanced+)
        (expt enhanced-expt))
    ;; Here is a definition of f(x), in the notation of Owl Lisp:
    (+ (+ (expt x 100) x) 1)))

;; Use f on regular integers.
(display "No modulus:  ")
(display (f 10))
(newline)

(display "modulus 13:  ")
(display (car (f (cons 10 13))))
(newline)
