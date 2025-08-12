(defun modpow (base exp mod)
  (cond ((= mod 1) 0)
        (t (do ((base (mod base mod) (mod (* base base) mod))
                (exp exp (ash exp -1))
                (result 1 (cond ((= (logand exp 1) 1) (mod (* result base) mod))
                                (t result))))
               ((zerop exp) result)))))

(defun primes-upto (limit)
  (let ((sieve (make-array limit :element-type 'boolean :initial-element t)))
    (when (plusp limit) (setf (svref sieve 0) nil))
    (when (> limit 1) (setf (svref sieve 1) nil))
    (loop for i from 4 below limit by 2
          do (setf (svref sieve i) nil))
    (loop for p = 3 then (+ p 2)
          for q = (expt p 2)
          while (< q limit)
          when (aref sieve p)
          do (loop with incr = (* 2 p)
                   while (< q limit)
                   do (setf (svref sieve q) nil)
                      (incf q incr)))
    sieve))

(defun wieferich-primes-upto (limit)
  (loop with sieve = (primes-upto limit)
        for p from 3 below limit by 2
        when (and (svref sieve p) (= (modpow 2 (1- p) (expt p 2)) 1))
        collect p))

(defparameter *check-upto-limit* 5000)

(format t "Wieferich primes less than ~a:~%~{~a~%~}"
          *check-upto-limit*
          (wieferich-primes-upto *check-upto-limit*))
