(require 'gnus-range)

(defun rangext (lst)
  (mapconcat (lambda (item)
               (if (consp item)
		   (if (= (+ 1 (car item)) (cdr item))
		       (format "%d,%d" (car item) (cdr item))
		     (format "%d-%d" (car item) (cdr item)))
                 (format "%d" item)))
             (gnus-compress-sequence lst)
             ","))

(rangext '(0  1  2  4  6  7  8  11 12 14
           15 16 17 18 19 20 21 22 23 24
           25 27 28 29 30 31 32 33 35 36
           37 38 39))
;; => "0-2,4,6-8,11,12,14-25,27-33,35-39"
