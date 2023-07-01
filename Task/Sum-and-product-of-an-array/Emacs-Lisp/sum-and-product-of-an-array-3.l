(require 'seq)

(let ((array [1 2 3 4 5]))
  (seq-reduce #'+ array 0)
  (seq-reduce #'* array 1))
