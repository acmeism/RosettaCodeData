CL-USER> (cartesian-product '(1 2) '(3 4))
((1 3) (1 4) (2 3) (2 4))
CL-USER> (cartesian-product '(3 4) '(1 2))
((3 1) (3 2) (4 1) (4 2))
CL-USER> (cartesian-product '(1 2) '())
NIL
CL-USER> (cartesian-product '() '(1 2))
NIL
