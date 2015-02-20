#lang racket
(struct A  (age name))
(struct B  (name nemesis))
(struct AB (name age nemesis) #:transparent)

(define Ages-table
  (list (A 27 "Jonah") (A 18 "Alan")
        (A 28 "Glory") (A 18 "Popeye")
        (A 28 "Alan")))

(define Nemeses-table
  (list
   (B "Jonah" "Whales") (B "Jonah" "Spiders")
   (B "Alan" "Ghosts") (B "Alan" "Zombies")
   (B "Glory" "Buffy")))

;; Hash phase
(define name->ages#
  (for/fold ((rv (hash)))
    ((a (in-list Ages-table)))
    (match-define (A age name) a)
    (hash-update rv name (λ (ages) (append ages (list age))) null)))

;; Join phase
(for*/list
    ((b (in-list Nemeses-table))
     (key (in-value (B-name b)))
     (age (in-list (hash-ref name->ages# key))))
  (AB key age (B-nemesis b)))
