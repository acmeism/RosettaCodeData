(loop for (number base) in '((1 10) (1234 10) (#xfe 16) (#xf0e 16))
      do (format t "(~a)_~a = ~a~%" number base (sum-digits number base)))
