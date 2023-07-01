;;
;; curry functional definition
;; (define (curry proc . left-args) (lambda right-args (apply proc (append left-args right-args))))
;;
;; right-curry
;; (define (rcurry proc . right-args) (lambda left-args (apply proc (append left-args right-args))))
;;

(define add42 (curry + 42))
(add42 666) → 708

(map (curry cons 'simon) '( gallubert garfunkel et-merveilles))
   →   ((simon . gallubert) (simon . garfunkel) (simon . et-merveilles))
(map (rcurry cons 'simon) '( gallubert garfunkel et-merveilles))
   →   ((gallubert . simon) (garfunkel . simon) (et-merveilles . simon))

;Implementation : result of currying :
(curry * 2 3 (+ 2 2))
    → (λ _#:g1004 (#apply-curry #* (2 3 4)  _#:g1004))
