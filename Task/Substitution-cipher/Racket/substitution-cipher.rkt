#lang racket/base
(require racket/list racket/function racket/file)

(define abc "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")

;; Used to generate my-key for examples
(define (random-key (alphabet abc))
  (list->string (shuffle (string->list alphabet))))

(define (cypher/decypher key (alphabet abc))
  ;; alist is fine, hashes are better over 40 chars... so alist for
  ;; abc, hash for ASCII.
  (define ab-chars (string->list alphabet))
  (define ky-chars (string->list key))
  (define cypher-alist (map cons ab-chars ky-chars))
  (define decypher-alist (map cons ky-chars ab-chars))
  (define ((subst-map alist) str)
    (list->string (map (lambda (c) (cond [(assoc c alist) => cdr] [else c]))
                       (string->list str))))
  (values (subst-map cypher-alist)
          (subst-map decypher-alist)))

(define (cypher/decypher-files key (alphabet abc))
  (define-values (cypher decypher) (cypher/decypher key alphabet))
  (define ((convert-file f) in out #:exists (exists-flag 'error))
     (curry with-output-to-file out #:exists exists-flag
            (lambda () (display (f (file->string in))))))
  (values (convert-file cypher)
          (convert-file decypher)))

(module+ test
  (require rackunit)
  (define my-key "LXRWzUrIYPJiVQyMwKudbAaDjSEefvhlqmOkGcBZCFsNpxHTgton")

  (define-values (cypher decypher) (cypher/decypher my-key abc))

  (define in-text #<<T
The quick brown fox...
.. jumped over
the lazy dog!
T
    )
  (define cypher-text (cypher in-text))

  (define plain-text (decypher cypher-text))
  (displayln cypher-text)
  (check-equal? plain-text in-text)

  (define-values (file-cypher file-decypher) (cypher/decypher-files my-key abc))
  (file-cypher "data/substitution.in.txt" "data/substitution.crypt.txt" #:exists 'replace)
  (file-decypher "data/substitution.crypt.txt" "data/substitution.plain.txt" #:exists 'replace)
  (displayln "---")
  (displayln (file->string "data/substitution.crypt.txt"))
  (check-equal? (file->string "data/substitution.in.txt")
                (file->string "data/substitution.plain.txt")))
