(defun alphap (char)
  (char<= #\A char #\Z))

(defun alpha-digit-char-p (char)
  (or (alphap char) (digit-char-p char)))

(defun valid-isin-format-p (isin)
  (and (= (length isin) 12)
       (alphap (char isin 0))
       (alphap (char isin 1))
       (loop for i from 2 to 10
             always (alpha-digit-char-p (char isin i)))
       (digit-char-p (char isin 11))))

(defun isin->digits (isin)
  (apply #'concatenate 'string
         (loop for c across isin
               collect (princ-to-string (digit-char-p c 36)))))

(defun luhn-test (string)
  (loop for c across (reverse string)
        for oddp = t then (not oddp)
        if oddp
          sum (digit-char-p c) into result
        else
          sum (let ((n (* 2 (digit-char-p c))))
                (if (> n 9) (- n 9) n))
            into result
        finally (return (zerop (mod result 10)))))

(defun valid-isin-p (isin)
  (and (valid-isin-format-p isin)
       (luhn-test (isin->digits isin))))

(defun test ()
  (dolist (isin '("US0378331005" "US0373831005" "U50378331005" "US03378331005"
                  "AU0000XVGZA3" "AU0000VXGZA3" "FR0000988040"))
    (format t "~A: ~:[invalid~;valid~]~%" isin (valid-isin-p isin))))
