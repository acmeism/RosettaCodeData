(lib 'types)
(lib 'struct)

(struct T (integer:x)) ;; super class
(struct S T (integer:y)) ;; sub class
(struct K (T:box)) ;; container class, box must be of type T, or derived

(define k-source (K (S 33 42)))
(define k-copy (copy k-source))

k-source
    → #<K> (#<S> (33 42)) ;; new container, with a S in box
k-copy
    → #<K> (#<S> (33 42)) ;; copied S type

(set-S-y! (K-box k-source) 666) ;; modify k-source.box.y

k-source
    → #<K> (#<S> (33 666)) ;; modified
k-copy
    → #<K> (#<S> (33 42))  ;; unmodified

(K "string-inside") ;; trying to put a string in the container box
😡 error: T : type-check failure : string-inside → 'K:box'
