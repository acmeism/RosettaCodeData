(include-book "arithmetic-3/top" :dir :system)

(defun sum-of-digit-squares (n)
   (if (zp n)
       0
       (+ (expt (mod n 10) 2)
          (sum-of-digit-squares (floor n 10)))))

(defun is-happy-r (n seen)
   (let ((next (sum-of-digit-squares n)))
        (cond ((= next 1) t)
              ((member next seen) nil)
              (t (is-happy-r next (cons next seen))))))

(defun is-happy (n)
   (is-happy-r n nil))

(defun first-happy-nums-r (n i)
   (cond ((zp n) nil)
         ((is-happy i)
          (cons i (first-happy-nums-r (1- n) (1+ i))))
         (t (first-happy-nums-r n (1+ i)))))

(defun first-happy-nums (n)
   (first-happy-nums-r n 1))
