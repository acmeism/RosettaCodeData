#lang racket
; An ITEM a list of three elements:
;   a name, a weight, and, a value

; A SOLUTION to a knapsack01 problems is a list of three elements:
;   the total value, the total weight, and, names of the items to bag

(define (add i s) ; add an item i to the solution s
  (match-define (list in iw iv) i)
  (match-define (list v w is) s)
  (list (+ v iv) (+ w iw) (cons in is)))

(define (knapsack max-weight items)
  ; return a solution to the knapsack01 problem
  (define ht (make-hash)) ; (weight number-of-items) -> items
  (define (get w no-items) (hash-ref ht (list w no-items) #f))
  (define (update w is x)  (hash-set! ht (list w (length is)) is) x)
  (define (knapsack1 left items)
    ; return a solution to the (left, items) problem
    (cond
      ; if there are no items, then bag no items:
      [(empty? items) (list 0 0 '())]
      ; look up the best solution:
      [(or (get left (length items))
           ; the solution haven't been cached, so we
           ; must compute it and update the cache:
           (update
            left items
            (match items
              ; let us name the first item
              [(cons (and (list i w v) x) more)
               ; if the first item weighs more than the space left,
               ; we simply find a solution, where it is omitted:
               (cond [(> w left) (knapsack left more)]
                     ; there is room for the first item, but
                     ; we need to choose the best solutions
                     ; between those with it and that without:
                     [else
                      (define without (knapsack left more))
                      (define value-without (first without))
                      (define with (knapsack (- left w) more))
                      (define value-with (+ (first with) v))
                      ; choose the solutions with greatest value
                      (if (> value-without value-with)
                          without
                          (add x with))])])))]))
  (knapsack1 max-weight items))

(knapsack 400
          '((map 9 150) ; 9 is weight, 150 is value
            (compass 13 35) (water 153 200) (sandwich 50 160)
            (glucose 15 60) (tin 68 45)(banana 27 60) (apple 39 40)
            (cheese 23 30) (beer 52 10) (cream 11 70) (camera 32 30)
            (T-shirt 24 15) (trousers 48 10) (umbrella 73 40)
            (trousers 42 70) (overclothes 43 75) (notecase 22 80)
            (glasses 7 20) (towel 18 12) (socks 4 50) (book 30 10)))
