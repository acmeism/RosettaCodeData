(defun odd (n)
  (if (oddp n) (format "%d is odd\n" n)
    (format "%d is even\n" n)))

(defun even (n)
  (if (evenp n) (format "%d is even\n" n)
    (format "%d is odd\n" n)))

(progn
  (insert (even 3) )
  (insert (odd 2) )))
