(let ((x (make-array '(1 11) :initial-contents '((0 1 2 3 4 5 6 7 8 9 10))))
      (y (make-array '(1 11) :initial-contents '((1 6 17 34 57 86 121 162 209 262 321)))))
  (polyfit x y 2))

#2A((0.9999999999999759d0) (2.000000000000005d0) (3.0d0))
