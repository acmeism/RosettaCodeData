;;  -*- lexical-binding: t; -*-
(mapcar #'funcall
        (mapcar (lambda (x)
                  (lambda ()
                    (* x x)))
                '(1 2 3 4 5 6 7 8 9 10)))
;; => (1 4 9 16 25 36 49 64 81 100)
