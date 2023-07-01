:set-state-ok t

(defun get-two-nums (state)
   (mv-let (_ a state)
           (read-object *standard-oi* state)
      (declare (ignore _))
      (mv-let (_ b state)
              (read-object *standard-oi* state)
         (declare (ignore _))
         (mv a b state))))

(defun integer-arithmetic (state)
   (mv-let (a b state)
           (get-two-nums state)
      (mv state
          (progn$ (cw "Sum:        ~x0~%" (+ a b))
                  (cw "Difference: ~x0~%" (- a b))
                  (cw "Product:    ~x0~%" (* a b))
                  (cw "Quotient:   ~x0~%" (floor a b))
                  (cw "Remainder:  ~x0~%" (mod a b))))))
