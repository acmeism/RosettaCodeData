(struct fenced-hash (actual original)
  #:extra-constructor-name *fenced-hash ;private constructor
  #:omit-define-syntaxes ;not sure this is a good idea
  #:methods gen:custom-write
  [(define write-proc *fenced-hash-print)]

  #:methods gen:dict
  [(define dict-ref fenced-hash-ref)
   (define dict-set! fenced-hash-set!)
   (define dict-remove! fenced-hash-remove!)
   (define dict-has-key? fenced-hash-has-key?) ;unused in 5.6.3
   (define dict-count fenced-hash-count)
   (define dict-iterate-first fenced-hash-iterate-first)
   (define dict-iterate-next fenced-hash-iterate-next)
   (define dict-iterate-key fenced-hash-iterate-key)
   (define dict-iterate-value fenced-hash-iterate-value)])


(define (fenced-hash . args) ; public constructor
  (define original (apply hash args))
  (*fenced-hash (hash-copy original) original))
