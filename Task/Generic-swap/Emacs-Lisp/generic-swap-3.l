(require 'cl-lib)
(defmacro swap (a b)
  `(cl-psetf ,a ,b
             ,b ,a))

(setq lst (list 123 456))
(swap (car lst) (cadr lst))
;; now lst is '(456 123)
