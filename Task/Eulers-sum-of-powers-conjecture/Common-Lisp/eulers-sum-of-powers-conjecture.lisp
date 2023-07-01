(ql:quickload :alexandria)
(let ((fifth-powers (mapcar #'(lambda (x) (expt x 5))
                            (alexandria:iota 250))))
  (loop named outer for x0 from 1 to (length fifth-powers) do
    (loop for x1 from 1 below x0 do
      (loop for x2 from 1 below x1 do
        (loop for x3 from 1 below x2 do
          (let ((x-sum (+ (nth x0 fifth-powers)
                          (nth x1 fifth-powers)
                          (nth x2 fifth-powers)
                          (nth x3 fifth-powers))))
            (if (member x-sum fifth-powers)
                  (return-from outer (list x0 x1 x2 x3 (round (expt x-sum 0.2)))))))))))
