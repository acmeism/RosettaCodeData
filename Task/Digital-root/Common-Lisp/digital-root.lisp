(defun digital-root (number &optional (base 10))
  (loop for n = number then s
        for ap = 1 then (1+ ap)
        for s = (sum-digits n base)
        when (< s base)
          return (values s ap)))

(loop for (nr base) in '((627615 10) (393900588225 10) (#X14e344 16) (#36Rdg9r 36))
      do (multiple-value-bind (dr ap) (digital-root nr base)
           (format T "~vR (base ~a): additive persistence = ~a, digital root = ~vR~%"
                   base nr base ap base dr)))
