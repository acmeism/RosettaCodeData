read %my-file         ;; read as binary (not like in Rebol2!)
read/string %my-file  ;; read as text (translates line terminators)
read/binary %my-file  ;; preserve contents exactly
read/lines %my-file   ;; read as block of strings
