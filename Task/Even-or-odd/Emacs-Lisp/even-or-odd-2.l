(defun odd (n)
  (if (= 1 (mod n 2) ) (format "%d is odd\n" n)
    (format "%d is even\n" n)))

(defun even (n)
  (if (= 0 (mod n 2) ) (format "%d is even\n" n)
    (format "%d is odd\n" n)))

(progn
  (insert (even 3) )
  (insert (odd 2) ))
