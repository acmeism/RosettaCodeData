(define make-list
  [A|D] -> [cons (make-list A) (make-list D)]
  X -> X)

(defmacro info-macro
  [info Exp] -> [output "~A: ~A~%" (make-list Exp) Exp])

(info (* 5 6)) \\ outputs [* 5 6]: 30
