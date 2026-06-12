(lib 'sequences) ;; for powerset

(define (sum0? xs)
	(zero? (apply + (map rest xs))))

;; filter the powerset and
;; take first 5 solutions
(for-each writeln (take (filter sum0? (powerset input)) 5))

()  ;; empty

(("archbishop" . -915) ("balm" . 397) ("bonnet" . 452)
("centipede" . -658) ("cobol" . 362) ("covariate" . 590)
("deploy" . 44) ("efferent" . 54) ("elysee" . -326))

(("archbishop" . -915) ("balm" . 397) ("bonnet" . 452)
("centipede" . -658) ("departure" . 952) ("deploy" . 44)
("efferent" . 54) ("elysee" . -326))

(("alliance" . -624) ("brute" . 870) ("centipede" . -658)
("cobol" . 362) ("elysee" . -326) ("eradicate" . 376))

(("alliance" . -624) ("archbishop" . -915) ("bonnet" . 452)
("centipede" . -658) ("cobol" . 362) ("covariate" . 590)
("deploy" . 44) ("diophantine" . 645) ("efferent" . 54)
("elysee" . -326) ("eradicate" . 376))
