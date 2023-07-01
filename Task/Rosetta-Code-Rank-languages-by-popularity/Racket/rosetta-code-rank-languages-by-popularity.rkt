#lang racket

(require racket/hash
         net/url
         json)

(define limit 15)
(define (replacer cat) (regexp-replace #rx"^Category:(.*?)$" cat "\\1"))
(define category "Category:Programming Languages")
(define entries "entries")

(define api-url (string->url "http://rosettacode.org/mw/api.php"))
(define (make-complete-url gcmcontinue)
  (struct-copy url api-url
               [query `([format . "json"]
                        [action . "query"]
                        [generator . "categorymembers"]
                        [gcmtitle . ,category]
                        [gcmlimit . "200"]
                        [gcmcontinue . ,gcmcontinue]
                        [continue . ""]
                        [prop . "categoryinfo"])]))

(define @ hash-ref)

(define table (make-hash))

(let loop ([gcmcontinue ""])
  (define resp (read-json (get-pure-port (make-complete-url gcmcontinue))))
  (hash-union! table
               (for/hash ([(k v) (in-hash (@ (@ resp 'query) 'pages))])
                 (values (@ v 'title #f) (@ (@ v 'categoryinfo (hash)) 'size 0))))
  (cond [(@ resp 'continue #f) => (λ (c) (loop (@ c 'gcmcontinue)))]))

(for/fold ([prev #f] [rank #f] #:result (void))
          ([item (in-list (sort (hash->list table) > #:key cdr))] [i (in-range limit)])
  (match-define (cons cat size) item)
  (define this-rank (if (equal? prev size) rank (add1 i)))
  (printf "Rank: ~a ~a ~a\n"
          (~a this-rank #:align 'right #:min-width 2)
          (~a (format "(~a ~a)" size entries) #:align 'right #:min-width 14)
          (replacer cat))
  (values size this-rank))
