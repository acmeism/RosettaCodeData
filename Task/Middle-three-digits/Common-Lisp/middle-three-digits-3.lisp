(defun mid3 (i)
  (let ((ch-vec (coerce (format nil "~A" (abs i)) 'vector)))
    (when (evenp (length ch-vec))
      (return-from mid3
        (format nil "Error: The number representation must have an odd ~
                     number of digits.")))

    (when (and (< i 100)
               (> i -100))
      (return-from mid3
        (format nil "Error: Must be >= 100 or <= -100.")))
    (let ((half (/ (1- (length ch-vec)) 2)))
      (return-from mid3 (format nil "~A~A~A"
                                   (elt ch-vec (1- half))
                                   (elt ch-vec half)
                                   (elt ch-vec (1+ half))))
      )))
