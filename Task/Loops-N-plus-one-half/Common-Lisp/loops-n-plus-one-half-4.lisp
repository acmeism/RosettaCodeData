(do ((i 1 (incf i)))			; Initialize to 1 and increment on every loop
    ((> i 10))				; Break condition
  (princ i)				; Print the iteration number
  (when (= i 10) (go end))		; Use the implicit tagbody and go to end tag when reach the last iteration
  (princ ", ")				; Printing the comma is jumped by the go statement
 end)					; The tag
