(defun coefficients (p)
  (cond
    ((= p 0) #(1))

    (t (loop for i from 1 upto p
             for result = #(1 -1) then (map 'vector
                                            #'-
                                            (concatenate 'vector result #(0))
                                            (concatenate 'vector #(0) result))
             finally (return result)))))

(defun primep (p)
  (cond
    ((< p 2) nil)

    (t (let ((c (coefficients p)))
         (decf (elt c 0))
         (loop for i from 0 upto (/ (length c) 2)
               for x across c
               never (/= (mod x p) 0))))))

(defun main ()
  (format t "# p: (x-1)^p for small p:~%")
  (loop for p from 0 upto 7
        do (format t "~D: " p)
           (loop for i from 0
                 for x across (reverse (coefficients p))
                 do (when (>= x 0) (format t "+"))
                    (format t "~D" x)
                    (if (> i 0)
                        (format t "X^~D " i)
                        (format t " ")))
           (format t "~%"))
  (loop for i from 0 to 50
        do (when (primep i) (format t "~D " i)))
  (format t "~%"))
