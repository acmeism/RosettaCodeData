(defun primep (n)
  "Is N prime?"
  (and (> n 1)
       (or (= n 2) (oddp n))
       (loop for i from 3 to (isqrt n) by 2
	  never (zerop (rem n i)))))

(defun reverse-digits (n)
  (labels ((next (n v)
             (if (zerop n) v
                 (multiple-value-bind (q r)
                     (truncate n 10)
                   (next q (+ (* v 10) r))))))
    (next n 0)))

(defun emirp (&key (count nil) (start 10) (end nil) (print-all nil))
  (do* ((n start (1+ n))
        (c count) )
       ((or (and count (<= c 0)) (and end (>= n end))))
    (when (and (primep n) (not (= n (reverse-digits n))) (primep (reverse-digits n)))
      (when print-all (format t "~a " n))
      (when count (decf c)) )))


(progn
  (format t "First 20 emirps: ") (emirp :count 20 :print-all t)
  (format t "~%Emirps between 7700 and 8000: ") (emirp :start 7700 :end 8000 :print-all t)
  (format t "~%The 10,000'th emirp: ") (emirp :count 10000 :print-all nil) )
