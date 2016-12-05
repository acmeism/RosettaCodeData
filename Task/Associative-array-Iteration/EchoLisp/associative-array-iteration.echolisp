(lib 'hash) ;; load hash.lib
(define H (make-hash))
;; fill hash table
(hash-set H 'Simon 42)
(hash-set H 'Albert 666)
(hash-set H 'Antoinette 33)

;; iterate over (key . value ) pairs
(for ([kv H]) (writeln kv))
(Simon . 42)
(Albert . 666)
(Antoinette . 33)

;; iterate over keys
(for ([k (hash-keys H)]) (writeln 'key-> k))
key->     Simon
key->     Albert
key->     Antoinette

;; iterate over values
(for ([v (hash-values H)]) (writeln 'value-> v))
value->     42
value->     666
value->     33
