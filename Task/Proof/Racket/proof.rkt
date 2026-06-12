#lang cur

(require rackunit
         cur/stdlib/equality
         cur/stdlib/sugar
         cur/ntac/base
         cur/ntac/standard
         cur/ntac/rewrite)

;; Task 1.1

(data nat : 0 Type
      [O : nat]
      [S : (-> nat nat)])

(define-syntax #%datum
  (syntax-parser
    [(_ . n:exact-nonnegative-integer)
     #:when (zero? (syntax-e #'n))
     #'O]
    [(_ . n:exact-nonnegative-integer)
     #`(S (#%datum . #,(- (syntax-e #'n) 1)))]))

(check-equal? (S (S (S (S O)))) 4)

;; Task 1.2

(data even : 0 (-> nat Type)
      [even-O : (even 0)]
      [even-SS : (forall [n : nat] (-> (even n) (even (S (S n)))))])

;; Task 1.3

(data odd : 0 (-> nat Type)
      [odd-O : (odd 1)]
      [odd-SS : (forall [n : nat] (-> (odd n) (odd (S (S n)))))])

;; Task 2.1

(define/rec/match + : nat [m : nat] -> nat
  [O => m]
  [(S n-1) => (S (+ n-1 m))])

(check-equal? (+ 2 3) 5)

;; Task 3.1

(define-theorem even-plus-even-is-even
  (∀ [n : nat] [m : nat] (-> (even n) (even m) (even (+ n m))))
  (by-intros n m Hn Hm)
  (by-induction Hn #:as [() (n* IHn)])

  ;; subgoal 1
  simpl
  by-assumption

  ;; subgoal 2
  (by-apply even-SS)
  by-assumption)

;; Task 3.2

(define-theorem addition-assoc
  (∀ [a : nat] [b : nat] [c : nat] (== nat (+ (+ a b) c) (+ a (+ b c))))

  (by-intros a b c)
  (by-induction a #:as [() (a-1 IHa)])

  ;; subgoal 1
  reflexivity

  ;; subgoal 2
  display-focus ; show how the context and goal are before rewrite
  (by-rewrite IHa)
  display-focus ; show how the context and goal are after rewrite
  reflexivity)
