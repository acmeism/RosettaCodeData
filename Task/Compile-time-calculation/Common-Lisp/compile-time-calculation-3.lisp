(defmacro ct-factorial (n)
  `(quote ,(factorial n)))

; or, equivalently,
(defmacro ct-factorial (n)
  `',(factorial n))
