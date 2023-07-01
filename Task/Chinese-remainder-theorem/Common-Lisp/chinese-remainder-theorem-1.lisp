(defun chinese-remainder (am)
"Calculates the Chinese Remainder for the given set of integer modulo pairs.
 Note: All the ni and the N must be coprimes."
  (loop :for (a . m) :in am
        :with mtot = (reduce #'* (mapcar #'(lambda(X) (cdr X)) am))
        :with sum  = 0
        :finally (return (mod sum mtot))
        :do
   (incf sum (* a (invmod (/ mtot m) m) (/ mtot m)))))
