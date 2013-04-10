(defun bitwise (a b)
  (print (logand a b))  ; AND
  (print (logior a b))  ; OR ("ior" = inclusive or)
  (print (logxor a b))  ; XOR
  (print (lognot a))    ; NOT
  (print (ash a b))     ; arithmetic left shift (positive 2nd arg)
  (print (ash a (- b))) ; arithmetic right shift (negative 2nd arg)
                        ; no logical shift
)
