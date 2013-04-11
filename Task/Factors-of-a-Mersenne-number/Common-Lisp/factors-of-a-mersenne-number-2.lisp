(defun primep (a)
  (cond ((= a 2) T)
        ((or (<= a 1) (= (mod a 2) 0)) nil)
        ((loop for i from 3 to (sqrt a) by 2 do
                (if (= (mod a i) 0)
                    (return nil))) nil)
        (T T)))

(defun primep (n)
  "Is N prime?"
  (and (> n 1)
       (or (= n 2) (oddp n))
       (loop for i from 3 to (isqrt n) by 2
	  never (zerop (rem n i)))))
