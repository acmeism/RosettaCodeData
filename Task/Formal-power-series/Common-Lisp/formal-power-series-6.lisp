(defparameter *sinx*
  (locally (declare (special *cosx*))
    (delay (int (force *cosx*)))))

(defparameter *cosx*
  (delay (- 1 (int *sinx*))))
