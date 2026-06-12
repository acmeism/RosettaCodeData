#lang racket
(module rules racket/base
  (require racket/match)

  (provide game-cross
           available-lines
           add-line
           line-dx.dy)

  (define (add-points points# x y . more)
    (define p+ (hash-set points# (cons x y) #t))
    (if (null? more) p+ (apply add-points p+ more)))

  ;; original cross
  (define (game-cross)
    (let ((x1 (for/fold ((x (hash))) ((i (in-range 3 7)))
                (add-points x 0 i i 0 9 i i 9))))
      (for/fold ((x x1)) ((i (in-sequences (in-range 0 4) (in-range 6 10))))
        (add-points x 3 i i 3 6 i i 6))))

  ;; add an edge
  (define (make-edge points#)
    (for*/hash ((k (in-hash-keys points#))
                (dx (in-range -1 2))
                (dy (in-range -1 2))
                (x (in-value (+ (car k) dx)))
                (y (in-value (+ (cdr k) dy)))
                (e (in-value (cons x y)))
                #:unless (hash-has-key? points# e))
      (values e #t)))

  (define (line-dx.dy d)
    (values (match d ['w -1] ['nw -1] ['n 0] [ne 1])
            (match d ['n -1] ['ne -1] ['nw -1] ['w 0])))

  (define (line-points e d)
    (define-values (dx dy) (line-dx.dy d))
    (match-define (cons x y) e)
    (for/list ((i (in-range 5)))
      (cons (+ x (* dx i))
            (+ y (* dy i)))))

  (define (line-overlaps? lp d l#)
    (for/first ((i (in-range 3))
                (p (in-list (cdr lp)))
                #:when (hash-has-key? l# (cons d p)))
      #t))

  (define (four-points? lp p#)
    (= 4 (for/sum ((p (in-list lp)) #:when (hash-has-key? p# p)) 1)))

  ;; returns a list of lines that can be applied to the game
  (define (available-lines p# l# (e# (make-edge p#)))
    (for*/list ((ep (in-sequences (in-hash-keys e#) (in-hash-keys p#)))
                (d (in-list '(n w ne nw)))
                (lp (in-value (line-points ep d)))
                #:unless (line-overlaps? lp d l#)
                #:when (four-points? lp p#))
      (define new-edge-point (for/first ((p (in-list lp)) #:when (hash-ref e# p #f)) p))
      (list ep d lp new-edge-point)))

  ;; adds a new line to points# lines# returns (values [new points#] [new lines#])
  (define (add-line line points# lines#)
    (match-define (list _ dir ps _) line)
    (for/fold ((p# points#) (l# lines#)) ((p (in-list ps)))
      (values (hash-set p# p #t) (hash-set l# (cons dir p) #t)))))

(module player racket/base
  (require racket/match
           (submod ".." rules))

  (provide play-game
           random-line-chooser)

  (define (random-line-chooser p# l# options)
    (list-ref options (random (length options))))

  ;; line-chooser (points lines (Listof line) -> line)
  (define (play-game line-chooser (o# (game-cross)))
    (let loop ((points# o#)
               (lines# (hash))
               (rv null))
      (match (available-lines points# lines#)
        [(list) (values points# (reverse rv) o#)]
        [options
         (match-define (and chosen-one (list (cons x y) d _ new-edge-point))
           (line-chooser points# lines# options))
         (define-values (p# l#) (add-line chosen-one points# lines#))
         (loop p# l# (cons (vector x y d new-edge-point) rv))]))))

;; [Render module code goes here]

(module main racket/base
  (require (submod ".." render)
           (submod ".." player)
           pict
           racket/class)
  (define p (call-with-values (λ () (play-game random-line-chooser)) render-state))
  p
  (define bmp (pict->bitmap p))
  (send bmp save-file "images/morpion.png" 'png))
