(ql:quickload :alexandria)
(defun rep-stringv (a-str &optional (max-rotation (floor (/ (length a-str) 2))))
  ;; Exit condition if no repetition found.
  (cond ((< max-rotation 1) "Not a repeating string")
        ;; Two checks:
        ;; 1. Truncated string must be equal to rotation by repetion size.
        ;; 2. Remaining chars (rest-str) are identical to starting chars (beg-str)
        ((let* ((trunc (* max-rotation (truncate (length a-str) max-rotation)))
                (truncated-str (subseq a-str 0 trunc))
                (rest-str (subseq a-str trunc))
                (beg-str (subseq a-str 0 (rem (length a-str) max-rotation))))
           (and (string= beg-str rest-str)
                (string= (alexandria:rotate (copy-seq truncated-str) max-rotation)
                         truncated-str)))
         ;; If both checks pass, return the repeting string.
         (subseq a-str 0 max-rotation))
        ;; Recurse function reducing length of rotation.
        (t (rep-stringv a-str (1- max-rotation)))))
