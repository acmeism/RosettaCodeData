(let ((count 10))                ; Create local variable count = 10
  (tagbody
   dec                           ; Create tag dec
    (print count)                ; Prints count
    (decf count)                 ; Decreases count
    (if (not (< count 0))        ; Ends loop when negative
        (go dec))))              ; Loops back to tag dec
