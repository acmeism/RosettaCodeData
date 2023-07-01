; simplest
(+ (read) (read))

; safe
(let ((a (read))
      (b (read)))
   (if (not (number? a))
      (runtime-error "a is not a number! got:" a))
   (if (not (number? b))
      (runtime-error "b is not a number! got:" b))

   (print a " + " b " = " (+ a b)))
