;there is no built-in way to set! append in racket
(define mystr "foo")
(set! mystr (string-append mystr " bar"))
(displayln mystr)

;but you can create a quick macro to solve that problem
(define-syntax-rule (set-append! str value)
  (set! str (string-append str value)))

(define mymacrostr "foo")
(set-append! mymacrostr " bar")
(displayln mystr)
