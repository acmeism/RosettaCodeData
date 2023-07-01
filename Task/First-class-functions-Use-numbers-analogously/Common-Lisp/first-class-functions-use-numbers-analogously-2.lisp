(defun compose (f g) (lambda (x) (funcall f (funcall g x))))
(defun cube (x) (expt x 3))
(defun cube-root (x) (expt x (/ 3)))

(loop with value = 0.5
      for function in (list #'sin  #'cos  #'cube     )
      for inverse  in (list #'asin #'acos #'cube-root)
      for composed = (compose inverse function)
      do (format t "~&(~A ∘ ~A)(~A) = ~A~%"
                 inverse
                 function
                 value
                 (funcall composed value)))
