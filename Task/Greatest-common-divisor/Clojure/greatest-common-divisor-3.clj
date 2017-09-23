(defn stein-gcd [a b]
  (cond
    (zero? a) b
    (zero? b) a
    (and (even? a) (even? b)) (* 2 (stein-gcd (unsigned-bit-shift-right a 1) (unsigned-bit-shift-right b 1)))
    (and (even? a) (odd? b)) (recur (unsigned-bit-shift-right a 1) b)
    (and (odd? a) (even? b)) (recur a (unsigned-bit-shift-right b 1))
    (and (odd? a) (odd? b)) (recur (unsigned-bit-shift-right (Math/abs (- a b)) 1) (min a b))))
