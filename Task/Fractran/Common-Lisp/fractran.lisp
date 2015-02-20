(defun fractran (n frac-list)
  (lambda ()
    (prog1
      n
      (when n
        (let ((f (find-if (lambda (frac)
                            (integerp (* n frac)))
                          frac-list)))
          (when f (setf n (* f n))))))))


;; test

(defvar *primes-ft* '(17/91 78/85 19/51 23/38 29/33 77/29 95/23
                      77/19 1/17 11/13 13/11 15/14 15/2 55/1))

(loop with fractran-instance = (fractran 2 *primes-ft*)
      repeat 20
      for next = (funcall fractran-instance)
      until (null next)
      do (print next))
