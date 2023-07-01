;there is no built-in way to set! prepend in racket
(define str "foo")
(set! str (string-append "bar " str))
(displayln str)

;but you can create a quick macro to solve that problem
(define-syntax-rule (set-prepend! str value)
  (set! str (string-append value str)))

(define macrostr " bar")
(set-prepend! macrostr "foo")
(displayln macrostr)
