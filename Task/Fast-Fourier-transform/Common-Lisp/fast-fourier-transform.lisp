(defun fft (x)
  (if (<= (length x) 1) x
    (let*
       (
         (even (fft (loop for i from 0 below (length x) by 2 collect (nth i x))))
         (odd (fft (loop for i from 1 below (length x) by 2 collect (nth i x))))
         (aux (loop for k from 0 below (/ (length x) 2) collect (* (exp (/ (* (complex 0 -2) pi k ) (length x))) (nth k odd))))
       )
       (append (mapcar #'+ even aux) (mapcar #'- even aux))
       )
    )
)

(mapcar (lambda (x) (format t "~a~&" x)) (fft '(1 1 1 1 0 0 0 0)))
