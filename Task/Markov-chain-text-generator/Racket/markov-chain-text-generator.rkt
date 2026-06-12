#lang racket

(define (pick xs) (list-ref xs (random (length xs))))

(define (markov path N limit)
  (define xs (string-split (file->string path)))
  (define database (make-hash))
  (let loop ([xs xs])
    (define-values (prefix suffix*) (split-at xs N))
    (match suffix*
      [(cons suffix _)
       (hash-update! database prefix (curry cons suffix) '())
       (loop (rest xs))]
      [_ (void)]))

  (define prefix (pick (hash-keys database)))

  (for/fold ([prefix prefix]
             [out (reverse prefix)]
             #:result (string-join (reverse out) " "))
            ([i (in-range limit)])
    (define suffixes (hash-ref database prefix #f))
    #:break (not suffixes)
    (define suffix (pick suffixes))
    (values (append (rest prefix) (list suffix)) (cons suffix out))))

(markov "alice_oz.txt" 3 300)
