(use srfi-197)  ;; chain
(use gauche.collection)

(define .salary  (cut  list-ref <> 2))
(define .dept last)

(define employee-data
  (chain  '(("Tyler Bennett" E10297 32000 D101)
            ("John Rappl" E21437 47000 D050)
            ("George Woltman" E00127 53500 D101)
            ("Adam Smith" E63535 18000 D202)
            ("Claire Buckman" E39876 27800 D202)
            ("David McClellan" E04242 41500 D101)
            ("Rich Holcomb" E01234 49500 D202)
            ("Nathan Adams" E41298 21900 D050)
            ("Richard Potter" E43128 15900 D101)
            ("David Motsinger" E27002 19250 D202)
            ("Tim Sampair" E03033 27000 D101)
            ("Kim Arlich" E10001 57000 D190)
            ("Timothy Grove" E16398 29900 D190))
    (group-collection _ :key .dept)
    (map (^d (sort d > .salary))  _)))

(define (foo n)
  (dolist (dept employee-data)
    (print (.dept (car dept)))
    (for-each
      (^e (apply format #t " ~15a ~a ~a\n" (take e 3)))
      (take* dept n))
    (print)))

(foo 2)

D101
 George Woltman  E00127 53500
 David McClellan E04242 41500

D050
 John Rappl      E21437 47000
 Nathan Adams    E41298 21900

D202
 Rich Holcomb    E01234 49500
 Claire Buckman  E39876 27800

D190
 Kim Arlich      E10001 57000
 Timothy Grove   E16398 29900


(foo 8000)

D101
 George Woltman  E00127 53500
 David McClellan E04242 41500
 Tyler Bennett   E10297 32000
 Tim Sampair     E03033 27000
 Richard Potter  E43128 15900

D050
 John Rappl      E21437 47000
 Nathan Adams    E41298 21900

D202
 Rich Holcomb    E01234 49500
 Claire Buckman  E39876 27800
 David Motsinger E27002 19250
 Adam Smith      E63535 18000

D190
 Kim Arlich      E10001 57000
 Timothy Grove   E16398 29900
