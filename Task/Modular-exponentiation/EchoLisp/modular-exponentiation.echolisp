(lib 'bigint)

(define a 2988348162058574136915891421498819466320163312926952423791023078876139)
(define b 2351399303373464486466122544523690094744975233415544072992656881240319)
(define m 1e40)

(powmod a b m)
    → 1527229998585248450016808958343740453059

;; powmod is a native function
;; it could be defined as follows :

(define (xpowmod base exp mod)
    (define result 1)
    (while ( !zero? exp)
        (when (odd? exp) (set! result (% (* result base) mod)))
    (/= exp 2)
    (set! base (% (* base base) mod)))
result)

(xpowmod a b m)
    → 1527229998585248450016808958343740453059
