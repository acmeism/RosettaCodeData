  (makunbound '*y*) ;; *y* no longer has a value; it is erroneous to evaluate *y*

  (setf *y* 43)     ;; *y* is bound again.
