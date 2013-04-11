(let ((s (format () "~s" (expt 5 (expt 4 (expt 3 2))))))
  (format t "~a...~a, length ~a" (subseq s 0 20)
          (subseq s (- (length s) 20)) (length s)))
