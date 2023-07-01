;; Solution from Common Lisp and Racket
(define-syntax-rule (set-append! str tail)
   (set! str (string-append str tail)))

(define name "Albert") → name

(set-append! name " de Jeumont-Schneidre")
name
   → "Albert de Jeumont-Schneidre"
