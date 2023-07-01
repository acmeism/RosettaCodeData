(defun quibble (inputs &optional oxford-comma)
    (define final
        (if (and (caddr inputs) oxford-comma)
            ", and "
            " and " ) )
    (defun comma-quibble (words)
        (cond
            ((null words) "")
            ((null (cdr words)) (car words))
            (t (begin
                (string-append (car words)
                    (if (caddr words)
                        (string-append ", " (comma-quibble (cdr words)))
                        (string-append final (cadr words))) ) ) ) ) )
    (string-append "{" (comma-quibble inputs) "}") )

; test cases:
(print (quibble '())) ; empty list
(print (quibble '("ABC")))
(print (quibble '("ABC" "DEF")))
(print (quibble '("ABC" "DEF" "G" "H")))

(newline)

; test cases using the Oxford comma:
(print (quibble '() t))
(print (quibble '("ABC") t))
(print (quibble '("ABC" "DEF") t))
(print (quibble '("ABC" "DEF" "G" "H") t))
