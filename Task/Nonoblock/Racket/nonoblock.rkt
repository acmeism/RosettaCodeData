#lang racket
(require racket/trace)

(define add1-to-car (match-lambda [(cons (app add1 p1) t) (cons p1 t)]))

;; inputs:
;;   cells  -- available cells
;;   blocks -- list of block widths
;; output:
;;   gap-block+gaps
;;   where gap-block+gaps is:
;;   (list gap)                            -- a single gap
;;   (list gap block-width gap-block+gaps) -- padding to left, a block, right hand side
(define (nonoblock cells blocks)
  (match* ((- cells (apply + (length blocks) -1 blocks)) #| padding available on both sides |# blocks)
    [(_ (list)) (list (list cells))] ; generates an empty list of padding

    [((? negative?) _) null] ; impossible to satisfy

    [((and avp
           ;; use add1 with in-range because we actually want from 0 to available-padding
           ;; without add1, in-range iterates from 0 to (available-padding - 1)
           (app add1 avp+1))
      (list block))
     (for/list ((l-pad (in-range 0 avp+1)))
       (define r-pad (- avp l-pad)) ; what remains goes to right
       (list l-pad block r-pad))]

    [((app add1 avp+1) (list block more-blocks ...))
     (for*/list ((l-pad (in-range 0 avp+1))
                 (cells-- (in-value (- cells block l-pad 1)))
                 (r-blocks (in-value (nonoblock cells-- more-blocks)))
                 (r-block (in-list r-blocks)))
       (list* l-pad block (add1-to-car r-block)))])) ; put a single space pad on left of r-block

(define (neat rslt)
  (define dots (curryr make-string #\.))
  (define Xes (curryr make-string #\X))
  (define inr
    (match-lambda
      [(list 0 (app Xes b) t ...)
       (string-append b (inr t))]
      [(list (app dots p) (app Xes b) t ...)
       (string-append p b (inr t))]
      [(list (app dots p)) p]))
  (define (neat-row r)
    (string-append "|" (inr r) "|"))
  (string-join (map neat-row rslt) "\n"))

(define (tst c b)
  (define rslt (nonoblock c b))
  (define rslt-l (length rslt))
  (printf "~a cells, ~a blocks => ~a~%~a~%" c b
          (match rslt-l
            [0 "impossible"]
            [1 "1 solution"]
            [(app (curry format "~a solutions") r) r])
          (neat rslt)))

(module+ test
  (tst  5 '[2 1])
  (tst  5 '[])
  (tst 10 '[8])
  (tst 15 '[2 3 2 3])
  (tst  5 '[2 3]))
