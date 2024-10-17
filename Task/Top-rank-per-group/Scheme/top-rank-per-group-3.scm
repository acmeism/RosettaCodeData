(define-syntax ainc!
  (syntax-rules ()
    [(_ alist key val func default)
     (let ((pair (assoc key alist)))
       (if pair
         (set-cdr! pair (func val (cdr pair)))
         (set! alist (cons (cons key (func val default)) alist))))]
    [(_ alist key val func)
     (ainc! alist key val func 0)]
    [(_ alist key val)
     (ainc! alist key val +)]
    [(_ alist key)
     (ainc! alist key 1)]))

(define .salary  (cut  list-ref <> 2))
(define .dept last)

(define employee-data
  '(("Tyler Bennett" E10297 32000 D101)
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
    ("Timothy Grove" E16398 29900 D190)))

(define (top-salaries n)
  (let ((table '()))
    (dolist (e employee-data)
      (ainc! table
        (.dept e)
        (list e)
        (lambda(new old) (merge new old > .salary))
        '()))
    (dolist (dept table)
      (print  (car dept))
      (for-each
        (^e (apply format #t " ~15a ~a ~a\n" (take e 3)))
        (take* (cdr dept) n))
      (print))))

(top-salaries 2)

D190
 Kim Arlich      E10001 57000
 Timothy Grove   E16398 29900

D202
 Rich Holcomb    E01234 49500
 Claire Buckman  E39876 27800

D050
 John Rappl      E21437 47000
 Nathan Adams    E41298 21900

D101
 George Woltman  E00127 53500
 David McClellan E04242 41500
