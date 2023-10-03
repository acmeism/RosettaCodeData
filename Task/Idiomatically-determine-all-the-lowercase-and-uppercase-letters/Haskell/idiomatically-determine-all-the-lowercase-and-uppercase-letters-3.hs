(let chars-between (comp range (map char-code) (... str)))

(str "Upper-case: " (chars-between 65 91) "
Lower-case: " (chars-between 97 123))
