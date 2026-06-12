(defun %%quad-asr-simpsons (f a fa b fb)
  (let* ((m (/ (+ a b) 2))
         (fm (funcall f m))
         (h (- b a)))
    ;; Common Lisp supports returning multiple values at once. There
    ;; is no need to return them explicitly as a data structure
    ;; (though that also could be done).
    (values m fm (* (/ h 6) (+ fa (* 4 fm) fb)))))

(defun %%quad-asr (f a fa b fb tol whole m fm depth)
  (multiple-value-bind (lm flm left)
      (%%quad-asr-simpsons f a fa m fm)
    (multiple-value-bind (rm frm right)
        (%%quad-asr-simpsons f m fm b fb)
      (let ((delta (- (+ left right) whole))
            (tol^ (/ tol 2)))
        (if (or (<= depth 0)
                (= tol^ tol)
                (<= (abs delta) (* 15 tol)))
            (+ left right (/ delta 15))
            (+ (%%quad-asr f a fa m fm tol^ left
                           lm flm (1- depth))
               (%%quad-asr f m fm b fb tol^ right
                           rm frm (1- depth))))))))

(defun quad-asr (f a b tol depth)
  (let ((fa (funcall f a))
        (fb (funcall f b)))
    (multiple-value-bind (m fm whole)
        (%%quad-asr-simpsons f a fa b fb)
      (%%quad-asr f a fa b fb tol whole m fm depth))))

(princ "estimated definite integral of sin(x) for x from 0 to 1: ")
(princ (quad-asr #'sin 0 1 1e-9 1000))
(terpri)
