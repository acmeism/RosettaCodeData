(defun char->value (c)
  (cond ((digit-char-p c 36))
        ((char= c #\*) 36)
        ((char= c #\@) 37)
        ((char= c #\#) 38)
        (t (error "Invalid character: ~A" c))))

(defun cusip-p (cusip)
  (and (= 9 (length cusip))
       (loop for i from 1 to 8
             for c across cusip
             for v = (char->value c)
             when (evenp i)
               do (setf v (* 2 v))
             sum (multiple-value-bind (quot rem) (floor v 10)
                   (+ quot rem))
               into sum
             finally (return (eql (digit-char-p (char cusip 8))
                                  (mod (- 10 (mod sum 10)) 10))))))

(defun main ()
  (dolist (cusip '("037833100" "17275R102" "38259P508" "594918104" "68389X106" "68389X105"))
    (format t "~A: ~A~%" cusip (cusip-p cusip))))
