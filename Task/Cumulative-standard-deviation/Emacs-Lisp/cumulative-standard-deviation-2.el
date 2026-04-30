(let ((x '(2 4 4 4 5 5 7 9)))
  (string-to-number (calc-eval "sqrt(vpvar($1))" nil (append '(vec) x))))
