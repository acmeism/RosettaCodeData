(import (scheme base)
        (scheme inexact)
        (scheme write))

(define (quad-asr f a b tol depth)
  (letrec ;; Recursive let, so %%quad-asr can call itself.
      ((%%quad-asr-simpsons
        (lambda (a fa b fb)
          (let* ((m (/ (+ a b) 2))
                 (fm (f m))
                 (h (- b a)))
            ;; Scheme supports returning multiple values at
            ;; once. There is no need to return them explicitly as
            ;; a data structure (though that also could be done).
            (values m fm (* (/ h 6) (+ fa (* 4 fm) fb))))))
       (%%quad-asr
        (lambda (a fa b fb tol whole m fm depth)
          ;; The R7RS standard specifies there must be
          ;; "let-values" and "let*-values" for receiving multiple
          ;; values. However, I do not want to assume its
          ;; presence. I will use the most widely supported
          ;; method, which is "call-with-values". (Typically
          ;; "let*-values" would be implemented as syntactic sugar
          ;; for the following.)
          (call-with-values
              (lambda () (%%quad-asr-simpsons a fa m fm))
            (lambda (lm flm left)
              (call-with-values
                  (lambda () (%%quad-asr-simpsons m fm b fb))
                (lambda (rm frm right)
                  (let ((delta (- (+ left right) whole))
                        (tol^ (/ tol 2)))
                    (if (or (<= depth 0)
                            (= tol^ tol)
                            (<= (abs delta) (* 15 tol)))
                        (+ left right (/ delta 15))
                        (+ (%%quad-asr a fa m fm tol^ left
                                       lm flm (- depth 1))
                           (%%quad-asr m fm b fb tol^ right
                                       rm frm (- depth 1))))))))))))
    (let ((fa (f a))
          (fb (f b)))
      (call-with-values (lambda () (%%quad-asr-simpsons a fa b fb))
        (lambda (m fm whole)
          (%%quad-asr a fa b fb tol whole m fm depth))))))

(display "estimated definite integral of sin(x) for x from 0 to 1: ")
(display (quad-asr sin 0 1 1e-9 1000))
(newline)
