(use-package :iterate)
(iter
  (for i from 1 to 5)
    (iter
      (for j from 1 to i)
      (princ #\*))
    (terpri))
