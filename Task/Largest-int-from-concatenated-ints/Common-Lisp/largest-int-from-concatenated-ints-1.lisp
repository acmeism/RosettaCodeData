(defun int-concat (ints)
  (read-from-string (format nil "~{~a~}" ints)))

(defun by-biggest-result (first second)
  (> (int-concat  (list first second)) (int-concat (list second first))))

(defun make-largest-int (ints)
  (int-concat (sort ints #'by-biggest-result)))
