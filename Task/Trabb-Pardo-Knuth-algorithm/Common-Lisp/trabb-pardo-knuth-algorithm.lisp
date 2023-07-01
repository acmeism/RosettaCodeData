(defun read-numbers ()
  (princ "Enter 11 numbers (space-separated): ")
  (let ((numbers '()))
    (dotimes (i 11 numbers)
      (push (read) numbers))))

(defun trabb-pardo-knuth (func overflowp)
  (let ((S (read-numbers)))
    (format T "~{~a~%~}"
            (substitute-if "Overflow!" overflowp (mapcar func S)))))

(trabb-pardo-knuth (lambda (x) (+ (expt (abs x) 0.5) (* 5 (expt x 3))))
                   (lambda (x) (> x 400)))
