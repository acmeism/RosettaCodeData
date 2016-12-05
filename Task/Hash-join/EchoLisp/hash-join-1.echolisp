(define ages '((27 "Jonah") (18 "Alan") (28 "Glory") (18 "Popeye") (28 "Alan")))
(define nemesis '(("Jonah" "Whales") ("Jonah" "Spiders") ("Alan" "Ghosts") ("Alan" "Zombies") ("Glory" "Buffy")))

;; table: table name
;; source : input list
;; key-proc : procedure returning the join value ('name' in this task)

(define (table-hash table source key-proc )
(local-make-store table)
(for ((r source))
	(local-put-value
		(key-proc r)
		(append (list r) (local-get-value (key-proc r) table)) table)))

;; build the two tables
(define-syntax-rule (second record) (cadr record))
(define (key-name-age record) (second record))
(table-hash 'AGES ages key-name-age)

(define (key-nemesis-name record) (first record))
(table-hash 'NEMESIS nemesis key-nemesis-name)

;; join
(for* ((k (local-keys 'AGES))
	  (a (local-get-value k 'AGES))
	  (n (local-get-value k 'NEMESIS)))
	  (writeln a n))
