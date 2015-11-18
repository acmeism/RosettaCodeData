(defun number-class (n)
  (let ((divisor-sum (sum-divisors n)))
    (cond ((< divisor-sum n) :deficient)
          ((= divisor-sum n) :perfect)
          ((> divisor-sum n) :abundant))))

(defun sum-divisors (n)
  (loop :for i :from 1 :to (/ n 2)
        :when (zerop (mod n i))
        :sum i))

(defun classification ()
  (loop :for n :from 1 :to 20000
        :for class := (number-class n)
        :count (eq class :deficient) :into deficient
        :count (eq class :perfect) :into perfect
        :count (eq class :abundant) :into abundant
        :finally (return (values deficient perfect abundant))))
