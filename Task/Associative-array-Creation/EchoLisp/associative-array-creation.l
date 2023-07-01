(lib 'hash) ;; needs hash.lib
(define H (make-hash)) ;; new hash table
;; keys may be symbols, numbers, strings ..
;; values may be any lisp object
(hash-set H 'simon 'antoniette)
   → antoniette
(hash-set H 'antoinette 'albert)
   → albert
(hash-set H "Elvis" 42)
    → 42
(hash-ref H 'Elvis)
    → #f ;; not found. Elvis is not "Elvis"
(hash-ref H "Elvis")
    → 42
(hash-ref H 'simon)
    → antoniette
(hash-count H)
    → 3
