;; 2^n
(define exp2 (build-vector 32 (lambda(i)(expt 2 i))))

;; counters and results
(define-values (*minlg* *counts* *chains* *calls*) '(0 null null 0))

(define (register-hit chain lg  )
(define idx (if (brauer? chain lg) 0 1))
    (when (< lg *minlg*)
        (set! *counts* (make-vector 2 0))
        (set! *chains* (make-vector 2 ""))
        (set! *minlg* lg))
    (vector+= *counts* idx 1)
    (vector-set! *chains* idx (vector->list chain)))

;; is chain a brauer chain ?
(define (brauer? chain lg)
    (for [(i (in-range 1 lg))]
        #:break (not (vector-search* (- [chain i] [chain (1- i)]) chain)) => #f
        #t))

;; all min chains to target n (brute force)
(define (chains n chain  lg   (a)  (top) (tops null))
(++ *calls*)
(set! top [chain  lg])
    (cond
    [(> lg *minlg*) #f] ;; too long
    [(= n top) (register-hit chain lg)]  ;; hit
    [(< n top) #f] ;; too big
    [(and (< *minlg* 32) (< (* top [exp2 (- *minlg* lg)]) n)) #f] ;; too small
    [else
    (for*  ([i (in-range lg -1 -1)] [j (in-range lg (1- i) -1)])
          (set! a (+ [chain i] [chain j]))
          #:continue (<= a top) ;; increasing sequence
          #:continue (memq a tops) ;; prevent duplicates
          (set! tops (cons a tops))
          (vector-push chain a)
          (chains n chain  (1+ lg))
          (vector-pop chain))]))


(define (task n)
    (set!-values (*minlg* *calls*) '(Infinity 0 ))
    (chains n (make-vector 1 1) 0)
    (printf "L(%d) = %d - brauer-chains: %d  non-brauer: %d  chains: %a %a "
         n *minlg* [*counts* 0] [*counts* 1] [*chains* 0] [*chains* 1]))
