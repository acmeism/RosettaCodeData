NB. demonstrate properties of arithmetic
'A B C' =: 3 ?@$ 0   NB. A B and C are random floating point numbers in range [0, 1).
((A + B) + C) -: (A + (B + C))  NB. addition associates
(A + B) -: (B + A)              NB. addition commutes
(A * B) -: (B * A)              NB. scalar multiplication commutes
(A * (B + C)) -: ((A * B) + (A * C)) NB. distributive property
