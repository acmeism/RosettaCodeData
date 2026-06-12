;(struct fenced-hash (actual original) ...)

(define (fenced-hash-ref dict
                         key
                         [default (lambda () (error "key not found" key))])
  (hash-ref (fenced-hash-actual dict) key default))
(define (fenced-hash-set! dict key val)
  (unless (hash-has-key? (fenced-hash-actual dict)  key)
    (error "unable to add key" key))
  (hash-set! (fenced-hash-actual dict) key val))
(define (fenced-hash-remove! dict key) ;reset the value!
  (unless (hash-has-key? (fenced-hash-actual dict) key)
    (error "key not found" key))
  (hash-set! (fenced-hash-actual dict)
             key
            (hash-ref (fenced-hash-original dict) key)))
(define (fenced-hash-clear! dict) ;reset all values!
  (hash-for-each (fenced-hash-original dict)
                 (lambda (key val) (hash-set! (fenced-hash-actual dict) key val))))

(define (fenced-hash-has-key? dict key)
  (hash-has-key? (fenced-hash-actual dict) key))
(define (fenced-hash-count dict)
  (hash-count (fenced-hash-actual dict)))

(define (fenced-hash-iterate-first dict)
  (hash-iterate-first (fenced-hash-actual dict)))
(define (fenced-hash-iterate-next dict pos)
  (hash-iterate-next (fenced-hash-actual dict) pos))
(define (fenced-hash-iterate-key dict pos)
  (hash-iterate-key (fenced-hash-actual dict) pos))
(define (fenced-hash-iterate-value dict pos)
  (hash-iterate-value (fenced-hash-actual dict) pos))

(define (*fenced-hash-print dict port mode)
        ;private custom-write ;mode is ignored
     (write-string "#fenced-hash" port)
     (write (hash->list (fenced-hash-actual dict)) port))
