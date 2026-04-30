(require 'cl-lib)
(let ((x 41))
  (cl-assert (= x 42) t "This shouldn't happen"))
