;; 1)
(define \a (first (string->unicode "a")))
(for/list ((i 25)) (unicode->string (+ i \a)))
    → (a b c d e f g h i j k l m n o p q r s t u v w x y)

;;2) using a sequence
(lib 'sequences)

(take ["a" .. "z"] 26)
    → (a b c d e f g h i j k l m n o p q r s t u v w x y z)

; or
(for/string ((letter ["a" .. "z"])) letter)
    → abcdefghijklmnopqrstuvwxyz
