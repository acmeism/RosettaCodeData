(defun Lychrel (number &optional (max 500))
 "Returns T if number is a candidate Lychrel (up to max iterations), and a second value with the sequence of sums"
  (do* ((n number (+ n (parse-integer rev-str)))
        (n-str (write-to-string n) (write-to-string n))
        (rev-str (reverse n-str) (reverse n-str))
        (i 0 (1+ i))
        (list (list n) (cons n list)) )
    ((or (> i max) (and (string= n-str rev-str) (> i 0))) (values (not (string= n-str rev-str)) (nreverse list)))))


(defun Lychrel-test (n &optional (max 500))
 "Tests the first n numbers up to max number of iterations"
  (let ((seeds nil)
        (related 0)
        (palyndromes nil) )
    (dotimes (i (1+ n))
      (multiple-value-bind (Lychrel-p seq) (Lychrel i max)
        (when Lychrel-p
          (if (find seq seeds :test #'intersection :key #'cdr)
            (incf related)
            (push (cons i seq) seeds) )
          (when (= i (parse-integer (reverse (write-to-string i))))
            (push i palyndromes) ))))
    (format T "Testing numbers: 1 to ~D~%Iteration maximum: ~D~%~%Number of Lychrel seeds found: ~d => ~a~%~
    Number of related found: ~D~%Palyndrome Lychrel numbers: ~D => ~a~%"
    n max (length seeds) (nreverse (mapcar #'car seeds)) related (length palyndromes) (nreverse palyndromes)) ))
