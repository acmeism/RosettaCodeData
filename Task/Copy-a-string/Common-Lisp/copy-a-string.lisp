(let* ((s1     "Hello")        ; s1 is a variable containing a string
       (s1-ref s1)             ; another variable with the same value
       (s2     (copy-seq s1))) ; s2 has a distinct string object with the same contents
  (assert (eq s1 s1-ref))      ; same object
  (assert (not (eq s1 s2)))    ; different object
  (assert (equal s1 s2))       ; same contents

  (fill s2 #\!)                ; overwrite s2
  (princ s1)
  (princ s2))                  ; will print "Hello!!!!!"
