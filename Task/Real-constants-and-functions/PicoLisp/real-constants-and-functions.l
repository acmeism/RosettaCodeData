(scl 12)  # 12 places after decimal point
(load "@lib/math.l")

(prinl (format (exp 1.0) *Scl))        # e, exp
(prinl (format pi *Scl))               # pi

(prinl (format (pow 2.0 0.5) *Scl))    # sqare root
(prinl (format (sqrt 2.0 1.0) *Scl))

(prinl (format (log 2.0) *Scl))        # logarithm
(prinl (format (exp 4.0) *Scl))        # exponential

(prinl (format (abs -7.2) *Scl))       # absolute value
(prinl (abs -123))

(prinl (format (pow 3.0 4.0) *Scl))    # power
