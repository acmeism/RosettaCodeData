>(define gcd (lambda (a b)
         (if (zero? b)
             a
             (gcd b (remainder a b)))))
>(define lcm (lambda (a b)
         (if (or (zero? a) (zero? b))
             0
             (abs (* b (floor (/ a (gcd a b))))))))
>(lcm 12 18)
36
