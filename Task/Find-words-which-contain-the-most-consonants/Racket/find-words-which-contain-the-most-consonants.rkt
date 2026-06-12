#lang racket

(define (consonant-count s)
  (set-count (set-subtract (list->set (string->list s))
                           (set #\a #\e #\i #\o #\u))))

(define words-by-consonant-count
  (group-by consonant-count (file->lines "../../data/unixdict.txt")))

(module+ main
  (define group-count (compose consonant-count first))
  (define group-with-max-consonant-count
    (argmax group-count words-by-consonant-count))
  (displayln "Group with gratest consonant count:")
  group-with-max-consonant-count
  (printf "with: ~a consonants in each word"
          (group-count group-with-max-consonant-count)))
