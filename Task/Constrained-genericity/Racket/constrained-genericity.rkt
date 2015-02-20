#lang racket
(module+ test (require tests/eli-tester))

;; This is all that an object should need to properly implement.
(define edible<%>
  (interface () [eat (->m void?)]))

(define (generic-container<%> containee/c)
  (interface ()
    [contents  (->m (listof containee/c))]
    [insert    (->m containee/c void?)]
    [remove-at (->m exact-nonnegative-integer? containee/c)]
    [count     (->m exact-nonnegative-integer?)]))

(define ((generic-box-mixin containee/c) %)
  (->i ([containee/c contract?])
       (rv (containee/c) (implementation?/c (generic-container<%> containee/c))))
  (class* % ((generic-container<%> containee/c))
    (super-new)
    (define l empty)
    (define/public (contents) l)
    (define/public (insert o) (set! l (cons o l)))
    (define/public (remove-at i)
      (begin0 (list-ref l i)
              (append (take l i) (drop l (add1 i)))))
    (define/public (count) (length l))))

;; As I understand it, a "Food Box" from the task is still a generic... i.e.
;; you will specify it down ;; to an "apple-box%" so: food-box%-generic is still
;; generic. food-box% will take any kind of food.
(define/contract (food-box-mixin T%)
  (-> (or/c (λ (i) (eq? edible<%> i)) (implementation?/c edible<%>))
   (make-mixin-contract))
  (generic-box-mixin (and/c (is-a?/c edible<%>) (is-a?/c T%))))

(module+ test

  (define integer-box% ((generic-box-mixin integer?) object%))
  (define integer-box  (new integer-box%))

  (define apple%
    (class* object% (edible<%>)
      (super-new)
      (define/public (eat)
        (displayln "nom!"))))

  (define banana%
    (class* object% (edible<%>)
      (super-new)
      (define/public (eat)
        (displayln "peel.. peel... nom... nom!"))))

  (define semolina%
    (class* object% () ; <-- empty interfaces clause
      (super-new)
      ;; you can call eat on it... but it's not explicitly (or even vaguely)
      ;; edible<%>
      (define/public (eat) (displayln "blech!"))))

  ;; this will take any object that is edible<%> and edible<%> (therefore all
  ;; edible<%> objects)
  (define any-food-box (new ((food-box-mixin edible<%>) object%)))

  ;; this will take any object that is edible and an apple<%>
  ;; (therefore only apple<%>s)
  (define apple-food-box (new ((food-box-mixin apple%) object%)))

  (test
   ;; Test generic boxes
   (send integer-box insert 22)
   (send integer-box insert "a string") =error> exn:fail:contract?

   ;; Test the food box that takes any edible<%>
   (send any-food-box insert (new apple%))
   (send any-food-box insert (new banana%))
   (send any-food-box insert (new semolina%)) =error> exn:fail:contract?

   ;; Test the food box that takes any apple%
   (send apple-food-box insert (new apple%))
   (send apple-food-box insert (new banana%)) =error> exn:fail:contract?
   (send apple-food-box insert (new semolina%)) =error> exn:fail:contract?
   (send apple-food-box count) => 1

   ;; Show that you cannot make a food-box from the non-edible<%> semolina cannot
   (implementation? semolina% edible<%>) => #f
   (new ((food-box-mixin semolina%) object%)) =error> exn:fail:contract?))
