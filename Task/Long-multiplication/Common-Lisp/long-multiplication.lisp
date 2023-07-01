(defun number->digits (number)
  (do ((digits '())) ((zerop number) digits)
    (multiple-value-bind (quotient remainder) (floor number 10)
      (setf number quotient)
      (push remainder digits))))

(defun digits->number (digits)
  (reduce #'(lambda (n d) (+ (* 10 n) d)) digits :initial-value 0))

(defun long-multiply (a b)
  (labels ((first-digit (list)
             "0 if list is empty, else first element of list."
             (if (endp list) 0
               (first list)))
           (long-add (digitses &optional (carry 0) (sum '()))
             "Do long addition on the list of lists of digits.  Each
              list of digits in digitses should begin with the least
              significant digit.  This is the opposite of the digit
              list returned by number->digits which places the most
              significant digit first.  The digits returned by
              long-add do have the most significant bit first."
             (if (every 'endp digitses)
               (nconc (number->digits carry) sum)
               (let ((column-sum (reduce '+ (mapcar #'first-digit digitses)
                                         :initial-value carry)))
                 (multiple-value-bind (carry column-digit)
                     (floor column-sum 10)
                   (long-add (mapcar 'rest digitses)
                             carry (list* column-digit sum)))))))
    ;; get the digits of a and b (least significant bit first), and
    ;; compute the zero padded rows. Then, add these rows (using
    ;; long-add) and convert the digits back to a number.
    (do ((a (nreverse (number->digits a)))
         (b (nreverse (number->digits b)))
         (prefix '() (list* 0 prefix))
         (rows '()))
        ((endp b) (digits->number (long-add rows)))
      (let* ((bi (pop b))
             (row (mapcar #'(lambda (ai) (* ai bi)) a)))
        (push (append prefix row) rows)))))
