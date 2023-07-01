;;;
;;; leo - calculates the first n number from a leo sequence.
;;; The first argument n is the number of values to return. The next three arguments a, b, add are optional.
;;; Default values provide the "original" leonardo numbers as defined in the task.
;;; a and b are the first and second element of the leonardo sequence.
;;; add is the "add number" as defined in the task definition.
;;;

(defun leo (n &optional (a 1) (b 1) (add 1))
  (labels ((iterate (n foo)
             (if (zerop n) (reverse foo)
                           (iterate (- n 1)
                                    (cons (+ (first foo) (second foo) add) foo)))))
     (cond ((= n 1) (list a))
           (T       (iterate (- n 2) (list b a))))))
