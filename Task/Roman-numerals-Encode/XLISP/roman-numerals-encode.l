(defun roman (n)
    (define roman-numerals '((1000 "m") (900 "cm") (500 "d") (400 "cd") (100 "c") (90 "xc") (50 "l") (40 "xl") (10 "x") (9 "ix") (5 "v") (4 "iv") (1 "i")))
    (defun romanize (arabic-numeral numerals roman-numeral)
        (if (= arabic-numeral 0)
            roman-numeral
            (if (>= arabic-numeral (caar numerals))
                (romanize (- arabic-numeral (caar numerals)) numerals (string-append roman-numeral (cadar numerals)))
                (romanize arabic-numeral (cdr numerals) roman-numeral))))
    (romanize n roman-numerals ""))

; test the function:
(display (mapcar roman '(10 2016 800 2769 1666 476 1453)))
