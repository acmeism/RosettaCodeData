(loop for count from 1
      for x in '(1 2 3 4 5)
      summing x into sum
      summing (* x x) into sum-of-squares
      finally
        (return
          (let* ((mean (/ sum count))
                 (spl-var (- (* count sum-of-squares) (* sum sum)))
                 (spl-dev (sqrt (/ spl-var (1- count)))))
            (values mean spl-var spl-dev))))
