(do	                                ; Not exactly separate statements for the number and the comma
 ((i 1 (incf i)))	                ; Initialize to 1 and increment on every loop
 ((> i 9) (princ i))                    ; Break condition when iteration is the last number, print it
  (princ i)	                        ; Print number statement
  (princ ", "))	                        ; Print comma statement
