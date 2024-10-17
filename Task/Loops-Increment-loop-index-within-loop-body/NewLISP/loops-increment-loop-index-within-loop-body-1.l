#! /usr/local/bin/newlisp

(define (prime? n)
 (and
   (set 'lst (factor n))
   (= (length lst) 1)))

(define (thousands_separator i)
    (setq i (string i))
    (setq len (length i))
    (setq i (reverse (explode i)))
    (setq o "")
    (setq count3 0)
    (dolist (x i)
        (setq o (string o x))
        (inc count3)
        (if (and (= 3 count3) (< (+ $idx 1) len))
            (begin
            (setq o (string o "_"))
            (setq count3 0))))

    (reverse o))


;- - - Main begins here
(setq i 42)
(setq n 0)
(while (< n 42)
    (if (prime? i)
        (begin
            (inc n)
            (println (string "n = " n " -> " (thousands_separator i)))
            (setq i (+ i i -1))))
    (inc i)
)

(exit)
