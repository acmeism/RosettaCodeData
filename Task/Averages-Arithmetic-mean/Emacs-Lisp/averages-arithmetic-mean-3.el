(let ((x '(1 2 3 4)))
  (string-to-number
   (math-format-value
    (calcFunc-vmean (cons 'vec x)))))
