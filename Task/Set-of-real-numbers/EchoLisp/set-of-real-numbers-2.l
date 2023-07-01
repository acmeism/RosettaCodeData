;; The following applies to convex sets ⟧...⟦ Cx,
;; and families F of disjoint convex sets.
;; Cx are implemented as vectors [lo, hi]

 (define-syntax-id _.lo [_ 0])
 (define-syntax-id _.hi [_ 1])

 ;; Cx-ops
 (define (Cx-new lo hi) (if (< lo hi) (vector lo hi) Cx-empty))
 (define (Cx-empty? A) (>= A.lo A.hi))
 (define  Cx-empty #(+Infinity -Infinity))
 (define (Cx-inter A B) (Cx-new (max A.lo B.lo) (min A.hi B.hi)))
 (define (Cx-measure A)  (if (< A.lo A.hi) (- A.hi A.lo) 0))

 ;; Families ops
 (define (CF-measure FA) (for/sum ((A FA)) (Cx-measure A))) ;; because disjoint
 ;; intersection of two families
 (define (CF-inter FA FB) (for*/list ((A FA)(B FB)) (Cx-inter A B)))
 ;; measure of FA/FB = m(FA) - m (FA ∩ FB)
 (define (CF-measure-FA/FB FA FB)
 	(- (CF-measure FA) (CF-measure (CF-inter FA FB))))

;; Application :
;; FA  = {x | 0 < x < 10 and |sin(π x²)| > 1/2 }
 (define FA
 	(for/list ((n 100))
          (Cx-new (sqrt (+ n (// 6))) (sqrt (+ n (// 5 6))))))

;; FB  = {x | 0 < x < 10 and |sin(π x)| > 1/2 }
 (define FB
 	(for/list ((n 10))
          (Cx-new (+ n (// 6)) (+ n (// 5 6)))))

→ (#(0.1667 0.8333) #(1.1667 1.8333) #(2.1667 2.8333)
 #(3.1667 3.8333) #(4.1667 4.8333) #(5.1667 5.8333)
 #(6.1667 6.8333) #(7.1667 7.8333) #(8.1667 8.8333) #(9.1667 9.8333))
 	
 (CF-measure-FA/FB FA FB)
      → 2.075864841184666
