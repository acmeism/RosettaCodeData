;;; check4munch maximum &optional b
;;; Return a list with all Munchausen numbers less then or equal to maximum.
;;; Checks are done in base b (<=10, dpower is the limiting factor here).
(defun check4munch (maximum &optional (base 10))
  (do ((n 1 (1+ n))
       (result NIL (if (munchp n base) (cons n result) result)))
      ((> n maximum)
       (nreverse result))))

;;;
;;; munchp n &optional b
;;; Return T if n is a Munchausen number in base b.
(defun munchp (n &optional (base 10))
   (if (= n (apply #'+ (mapcar #'dpower (n2base n base)))) T NIL))

;;; dpower d
;;; Returns d^d. I.e. the digit to the power of itself.
;;; 0^0 is set to 0. For discussion see e.g. the wikipedia entry.
;;; This function is mainly performance optimization.
(defun dpower (d)
  (aref #(0 1 4 27 256 3125 45556 823543 16777216 387420489) d))

;;; divmod a b
;;; Return (q,k) such that a = b*q + k and k>=0.
(defun divmod (a b)
  (let ((foo (mod a b)))
    (list (/ (- a foo) b) foo)))

;;; n2base n &optional b
;;; Return a list with the digits of n in base b representation.
(defun n2base (n &optional (base 10) (digits NIL))
  (if (zerop n) digits
                (let ((dm (divmod n base)))
                  (n2base (car dm) base (cons (cadr dm) digits)))))
