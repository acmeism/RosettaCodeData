(lib 'match)

(define (quibble words)
    (match words
         [ null "{}"]
         [ (a)  (format "{ %a }" a)]
         [ (a b) (format "{ %a and %a }" a b)]
         [( a ... b c) (format "{ %a %a and %a }" (for/string ([w a]) (string-append w ", "))  b c)]
         [else 'bad-input]))


;; output

 (for ([t '(() ("ABC") ("ABC" "DEF") ("ABC" "DEF" "G" "H"))])
    (writeln t '----> (quibble t)))

null     ---->     "{}"
("ABC")     ---->     "{ ABC }"
("ABC" "DEF")     ---->     "{ ABC and DEF }"
("ABC" "DEF" "G" "H")     ---->     "{ ABC, DEF, G and H }"
