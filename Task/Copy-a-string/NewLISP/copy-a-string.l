(define (assert f msg) (if (not f) (println msg)))

(setq  s "Greetings!"  c (copy s))
(reverse c) ; Modifies c in place.

(assert (= s c) "Strings not equal.")

; another way
; Nehal-Singhal 2018-05-25

> (setq a "abcd")
"abcd"
> (setq b a)
"abcd"
> b
"abcd"
> (= a b)
true
