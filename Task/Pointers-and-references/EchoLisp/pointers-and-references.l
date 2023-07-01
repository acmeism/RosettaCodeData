(define B (box 42))
    → B ;; box reference
(unbox B)
    → 42 ;; box contents

;; sets new value for box contents
(define ( change-by-ref abox avalue)
    (set-box! abox avalue) )

(change-by-ref B 666)
    → #[box 666]
(unbox B)
    → 666
