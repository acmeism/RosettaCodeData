; file:   write-float-array.lsp
; url:    http://rosettacode.org/wiki/Write_float_arrays_to_a_text_file
; author: oofoe 2012-01-30

; The "transpose" function is used to flip the joined lists around so
; that it's easier to iterate through them together.

(define (write-float-array x xp y yp filename)
  (let ((f (format "%%-10.%dg %%-10.%dg" xp yp))
        (o (open filename "write")))
    (dolist (v (transpose (list x y)))
      (write-line o (format f (v 0) (v 1))))
    (close o)
  ))

; Test

(write-float-array
 '(1 2 3 1e11) 3
 '(1 1.4142135623730951 1.7320508075688772 316227.76601683791) 5
 "filename.chan")

(println "File contents:")
(print (read-file "filename.chan"))

(exit)
