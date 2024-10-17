(printf "~%Basic examples:~%")
(for-each
  (lambda (rat)
    (printf "~a = ~a~%" rat (rat->cf-string rat))
    (printf "~a : ~a~%" rat (rat->cf-list rat)))
  '(1/2 3 23/8 13/11 22/7 -151/77 0))

(printf "~%Root2 approximations:~%")
(for-each
  (lambda (rat)
    (printf "~a = ~a~%" rat (rat->cf-string rat))
    (printf "~a : ~a~%" rat (rat->cf-list rat)))
  '(14142/10000 141421/100000 1414214/1000000 14142136/10000000 141421356237/100000000000))

(printf "~%Pi approximations:~%")
(for-each
  (lambda (rat)
    (printf "~a = ~a~%" rat (rat->cf-string rat))
    (printf "~a : ~a~%" rat (rat->cf-list rat)))
  '(31/10 314/100 3142/1000 31428/10000 314285/100000 3142857/1000000
    31428571/10000000 314285714/100000000 31415926535898/10000000000000))
