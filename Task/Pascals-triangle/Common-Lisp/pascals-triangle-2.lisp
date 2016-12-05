(defun pascal-next-row (a)
    (loop :for q :in a
          :and p = 0 :then q
          :as s = (list (+ p q))
          :nconc s :into a
          :finally (rplacd s (list 1))
                   (return a)))

(defun pascal (n)
    (loop :for a = (list 1) :then (pascal-next-row a)
          :repeat n
          :collect a))
