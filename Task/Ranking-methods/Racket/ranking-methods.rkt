#lang racket
;; Tim-brown 2014-09-11

;; produces a ranking according to ranking function: rfn
;; INPUT:
;;  lst : (list (score . details))
;;  rfn : (length-scores)
;;         -> (values
;;              ranks-added                  ; how many ranks to add for the next iteration
;;              (idx . rest -> rank-offset)) ; function that produces the rank for the idx^th element
;;                                           ; in the scoring (arity must be >= 1)
(define (rank-list all-scores rfn)
  (let loop ((rank-0 0) (lst (sort all-scores > #:key car)) (acc empty))
    (cond
      [(null? lst) acc]
      [else
       (define 1st-score (caar lst))
       (define (ties-with-1st? cand) (= (car cand) 1st-score))
       (define-values (tied unranked) (splitf-at lst ties-with-1st?))
       ;; all ranking functions should properly handle a singleton tied list
       (define tied-len (length tied))
       (define tied? (> tied-len 1))
       (define-values (ranks-added rank-offset-fn) (rfn tied-len))
       (define ranked-tied (for/list ((t (in-list tied)) (i (in-naturals 1)))
                             (list* tied? (+ rank-0 (rank-offset-fn i)) t)))
       (loop (+ ranks-added rank-0) unranked (append acc ranked-tied))])))

;; Ties share what would have been their first ordinal number
(define (rank-function:Standard l)
  (values l (thunk* 1)))

;; Ties share what would have been their last ordinal number
(define (rank-function:Modified l)
  (values l (thunk* l)))

;; Ties share the next available integer
(define (rank-function:Dense l)
  (values 1 (thunk* 1)))

;; Competitors take the next available integer. Ties are not treated otherwise
(define (rank-function:Ordinal l)
  (values l (λ (n . _) n)))

;; Ties share the mean of what would have been their ordinal numbers
(define (rank-function:Fractional l)
  (values l (thunk* (/ (+ l 1) 2))))

(define score-board
  '((44 . Solomon)
    (42 . Jason)
    (42 . Errol)
    (41 . Garry)
    (41 . Bernard)
    (41 . Barry)
    (39 . Stephen)))

(define format-number
  (match-lambda
    [(? integer? i) i]
    [(and f (app numerator n) (app denominator d))
     (define-values (q r) (quotient/remainder n d))
     (format "~a ~a/~a" q r d)]))

(for ((fn (list
           rank-function:Standard
           rank-function:Modified
           rank-function:Dense
           rank-function:Ordinal
           rank-function:Fractional)))
  (printf "Function: ~s~%" fn)
  (for ((r (in-list (rank-list score-board fn))))
    (printf "~a ~a\t~a\t~a~%"
            (if (car r) "=" " ")
            (format-number (cadr r))
            (caddr r)
            (cdddr r)))
  (newline))
