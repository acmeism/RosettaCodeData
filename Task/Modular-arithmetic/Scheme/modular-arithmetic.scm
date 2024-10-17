(cond-expand
  (r7rs)
  (chicken (import r7rs)))

(import (scheme base))
(import (scheme write))

(define *modulus*
  (make-parameter
   #f
   (lambda (mod)
     (if (or (not mod)
             (and (exact-integer? mod)
                  (positive? mod)))
         mod
         (error "not a valid modulus")))))

(define-syntax enhanced-op
  (syntax-rules ()
    ((_ op)
     (lambda args
       (let ((mod (*modulus*))
             (tentative-result (apply op args)))
         (if mod
             (floor-remainder tentative-result mod)
             tentative-result))))))

(define enhanced+ (enhanced-op +))
(define enhanced-expt (enhanced-op expt))

(define (f x)
  ;; Temporarily redefine + and expt so they can handle either regular
  ;; numbers or modular integers.
  (let ((+ enhanced+)
        (expt enhanced-expt))
    ;; Here is a definition of f(x), in the notation of Scheme:
    (+ (expt x 100) x 1)))

;; Use f on regular integers.
(display "No modulus:  ")
(display (f 10))
(newline)

;; Use f on modular integers.
(parameterize ((*modulus* 13))
  (display "modulus 13:  ")
  (display (f 10))
  (newline))
