#lang racket
(require math)
(define in (open-input-file "function-frequency.rkt"))
(void (read-language in))
(define s-exprs (for/list ([s (in-port read in)]) s))
(define symbols (filter symbol? (flatten s-exprs)))
(define counts  (sort (hash->list (samples->hash symbols)) >= #:key cdr))
(take counts (min 10 (length counts)))
