(include-book "arithmetic-3/top" :dir :system)

(defun digits (n)
   (if (zp n)
       nil
       (cons (mod n 10)
             (digits (floor n 10)))))

(defun sum (xs)
   (if (endp xs)
       0
       (+ (first xs)
          (sum (rest xs)))))

(defun double-and-sum-digits (xs)
   (if (endp xs)
       nil
       (cons (sum (digits (* 2 (first xs))))
             (double-and-sum-digits (rest xs)))))

(defun dmx (xs)
   (if (endp (rest xs))
       (mv xs nil)
       (mv-let (odds evens)
               (dmx (rest (rest xs)))
          (mv (cons (first xs) odds)
              (cons (second xs) evens)))))

(defun luhn (n)
   (mv-let (odds evens)
           (dmx (digits n))
      (= (mod (+ (sum odds)
                 (sum (double-and-sum-digits evens)))
              10)
         0)))
