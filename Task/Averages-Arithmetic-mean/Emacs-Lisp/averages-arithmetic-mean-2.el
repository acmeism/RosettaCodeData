(let ((x '(1 2 3 4)))
  (calc-eval "vmean($1)" nil (append '(vec) x)))
