#!/usr/local/bin/newlisp

(context 'KR)

(define (Kraitchik year month day)
    ; See https://en.wikipedia.org/wiki/Determination_of_the_day_of_the_week#Kraitchik.27s_variation
    ; Function adapted for specific task (not for general usage).
    (if (or (= 1 month) (= 2 month))
        (dec year)
    )
    ;- - - -
    (setf m-table '(_ 1 4 3 6 1 4 6 2 5 0 3 5)) ; - - - First element of list is dummy!
    (setf m (m-table month))
    ;- - - -
    (setf c-table '(0 5 3 1))
    (setf century%4 (mod (int (slice (string year) 0 2)) 4))
    (setf c (c-table century%4))
    ;- - - -
    (setf yy* (slice (string year) -2))
    (if (= "0" (yy* 0))
        (setf yy* (yy* 1))
    )
    (setf yy (int yy*))
    (setf y  (mod (+ (/ yy 4) yy) 7))
    ;- - - -
    (setf dow-table '(6 0 1 2 3 4 5))
    (dow-table (mod (+ day m c y) 7))
)

(context 'MAIN)

(setf Fives 0)
(setf NotFives 0)
(setf Report '())
(setf months-table '((1 "Jan") (3 "Mar") (5 "May") (7 "Jul") (8 "Aug") (10 "Oct") (12 "Dec")))

(for (y 1900 2100)
    (setf FivesFound 0)
    (setf Names "")
    (dolist (m '(1 3 5 7 8 10 12))
        (setf Dow (KR:Kraitchik y m 1))
        (if (= 5 Dow)
            (begin
                (++ FivesFound)
                (setf Names (string Names " " (lookup m months-table)))
            )
        )
    )

    (if (zero? FivesFound)
        (++ NotFives)
        (begin
            (setf Report (append Report (list (list y FivesFound (string "(" Names " )")))))
            (setf Fives (+ Fives FivesFound))
        )
    )
)


;- - - - Display all report data
;(dolist (x Report)
;    (println (x 0) ": " (x 1) " " (x 2))
;)


;- - - - Display only first five and last five records
(dolist (x (slice Report 0 5))
    (println (x 0) ": " (x 1) " " (x 2))
)
(println "...")
(dolist (x (slice Report -5))
    (println (x 0) ": " (x 1) " " (x 2))
)

(println "\nTotal months with five weekends: " Fives)
(println "Years with no five weekends months: " NotFives)
(exit)
