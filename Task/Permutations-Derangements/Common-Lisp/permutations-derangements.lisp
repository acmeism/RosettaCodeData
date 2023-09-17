(defun subfact (n)
  (cond
    ((= n 0) 1)
    ((= n 1) 0)
    (t (* (- n 1)
          (+ (subfact (- n 1))
             (subfact (- n 2)))))))

(defun count-derangements (n)
  (let ((count 0))
    (visit-derangements (range 1 n)
      (lambda (d) (declare (ignore d)) (incf count)))
    count))

(defun visit-derangements (items visitor)
  (visit-permutations items
    (lambda (p)
      (when (derangement-p items p)
        (funcall visitor p)))))

(defun derangement-p (original d)
  (notany #'equal original d))

(defun visit-permutations (items visitor)
  (labels
      ((vp (items perm)
         (cond ((null items)
                (funcall visitor (reverse perm)))
               (t
                (mapc (lambda (i)
                        (vp (remove i items)
                            (cons i perm)))
                      items)))))
    (vp items '())))

(defun range (start end)
  (loop for i from start to end collect i))

(defun examples ()
  (show-derangements '(1 2 3 4))
  (format t "~%n  counted     !n~%")
  (dotimes (i 10)
    (format t "~S ~7@S ~7@S~%"
            i
            (count-derangements i)
            (subfact i)))
  (format t "~%!20 = ~S~2%" (subfact 20)))

(defun show-derangements (items)
  (format t "~%Derangements of ~S~%" items)
  (visit-derangements items
    (lambda (d)
      (format t "  ~S~%" d))))
