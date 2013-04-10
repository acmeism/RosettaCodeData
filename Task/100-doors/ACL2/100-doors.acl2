(defun rep (n x)
   (if (zp n)
       nil
       (cons x
             (rep (- n 1) x))))

(defun toggle-every-r (n i bs)
   (if (endp bs)
       nil
       (cons (if (zp i)
                 (not (first bs))
                 (first bs))
             (toggle-every-r n (mod (1- i) n) (rest bs)))))

(defun toggle-every (n bs)
   (toggle-every-r n (1- n) bs))

(defun 100-doors (i doors)
   (if (zp i)
       doors
       (100-doors (1- i) (toggle-every i doors))))
