(defun ludic-numbers (max &optional n)
  (loop with numbers = (make-array (1+ max) :element-type 'boolean :initial-element t)
        for i from 2 to max
        until (and n (= num-results (1- n))) ; 1 will be added at the end
        when (aref numbers i)
          collect i into results
          and count t into num-results
          and do (loop for j from i to max
                       count (aref numbers j) into counter
                       when (= (mod counter i) 1)
                         do (setf (aref numbers j) nil))
        finally (return (cons 1 results))))

(defun main ()
  (format t "First 25 ludic numbers:~%")
  (format t "~{~D~^ ~}~%" (ludic-numbers 100 25))
  (terpri)
  (format t "How many ludic numbers <= 1000?~%")
  (format t "~D~%" (length (ludic-numbers 1000)))
  (terpri)
  (let ((numbers (ludic-numbers 30000 2005)))
    (format t "~{#~D: ~D~%~}"
            (mapcan #'list '(2000 2001 2002 2003 2004 2005) (nthcdr 1999 numbers))))
  (terpri)
  (loop with numbers = (ludic-numbers 250)
          initially (format t "Triplets:~%")
        for x in numbers
        when (and (find (+ x 2) numbers)
                  (find (+ x 6) numbers))
          do (format t "~3D ~3D ~3D~%" x (+ x 2) (+ x 6))))
