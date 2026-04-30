(progn
  (defun LargestProperDivisor (n / x)
    (cond
      ((= 1 n) n)
      ((> n 1)
        (setq x (1- n))
        (while (not (zerop (rem n x)))
          (setq x (1- x))
        )
        x
      )
    )
  )
  ((lambda ( / cnt nums)
    (mapcar
      'LargestProperDivisor
      (repeat (1- (setq cnt 101))
        (setq nums (cons (setq cnt (1- cnt)) nums))
      )
    )
  ))
)
