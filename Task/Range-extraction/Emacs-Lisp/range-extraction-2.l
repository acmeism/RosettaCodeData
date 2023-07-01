(defun split-into-ranges (numbers)
  (let* ((last-number (pop numbers))
         (range (list last-number))
         ranges)
    (dolist (n numbers)
      (if (= n (1+ last-number))
          (push n range)
        (push (nreverse range) ranges)
        (setq range (list n)))
      (setq last-number n))
    (nreverse (cons (nreverse range) ranges))))

(defun format-range (range)
  (cond
   ((not range)
    (error "invalid range"))
   ((= (length range) 1)
    (number-to-string (car range)))
   ((= (length range) 2)
    (format "%d,%d" (car range) (cadr range)))
   (t
    (format "%d-%d" (car range) (car (last range))))))

(defun rangext (numbers)
  (mapconcat #'format-range (split-into-ranges numbers) ","))

(rangext '(0  1  2  4  6  7  8  11 12 14
           15 16 17 18 19 20 21 22 23 24
           25 27 28 29 30 31 32 33 35 36
           37 38 39))
;; => "0-2,4,6-8,11,12,14-25,27-33,35-39"
