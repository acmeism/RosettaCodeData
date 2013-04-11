(defun sum (xs)
   (if (endp xs)
       0
       (+ (first xs)
          (sum (rest xs)))))

(defun n-bonacci (prevs limit)
   (if (zp limit)
       nil
       (let ((next (append (rest prevs)
                           (list (sum prevs)))))
            (cons (first next)
                  (n-bonacci next (1- limit))))))
