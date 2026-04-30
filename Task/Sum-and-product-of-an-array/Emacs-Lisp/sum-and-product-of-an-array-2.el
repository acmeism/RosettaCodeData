(require 'cl-lib)

(let ((array [1 2 3 4 5]))
  (cl-reduce #'+ array)
  (cl-reduce #'* array))
