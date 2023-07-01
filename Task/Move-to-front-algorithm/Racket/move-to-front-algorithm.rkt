#lang racket
(define default-symtab "abcdefghijklmnopqrstuvwxyz")

(define (move-to-front:encode in (symtab default-symtab))
  (define inner-encode
    (match-lambda**
     [((? string? (app string->list in)) st acc) ; make input all listy
      (inner-encode in st acc)]
     [(in (? string? (app string->list st)) acc) ; make symtab all listy
      (inner-encode in st acc)]
     [((list) _ (app reverse rv)) ; nothing more to encode
      rv]
     [((list a tail ...) (list left ... a right ...) acc) ; encode and recur
      (inner-encode tail `(,a ,@left ,@right) (cons (length left) acc))]))
  (inner-encode in symtab null))

(define (move-to-front:decode in (symtab default-symtab))
  (define inner-decode
    (match-lambda**
     [(in (? string? (app string->list st)) acc) ; make symtab all listy
      (inner-decode in st acc)]
     [((list) _ (app (compose list->string reverse) rv)) ; nothing more to encode
      rv]
     [((list a tail ...) symbols acc) ; decode and recur
      (match/values
       (split-at symbols a)
       [(l (cons ra rd))
        (inner-decode tail (cons ra (append l rd)) (cons ra acc))])]))
  (inner-decode in symtab null))

(module+ test
  ;; Test against the example in the task
  (require rackunit)
  (check-equal? (move-to-front:encode "broood") '(1 17 15 0 0 5))
  (check-equal? (move-to-front:decode '(1 17 15 0 0 5)) "broood")
  (check-equal? (move-to-front:decode (move-to-front:encode "broood")) "broood"))

(module+ main
  (define (encode+decode-string str)
    (define enc (move-to-front:encode str))
    (define dec (move-to-front:decode enc))
    (define crt (if (equal? dec str) "correctly" "incorrectly"))
    (printf "~s encodes to ~s, which decodes ~s to ~s.~%" str enc crt dec))

  (for-each encode+decode-string '("broood" "bananaaa" "hiphophiphop")))
