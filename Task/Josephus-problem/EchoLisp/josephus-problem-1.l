;; input
(define N 41)
(define K 3)
(define prisoners (apply circular-list (iota N)))
(define last-one prisoners) ; current position

;; kill returns current position = last killed
(define (kill lst skip)
(cond
    ((eq? (mark? lst) '🔫 )(kill (cdr lst) skip)) ;; dead ? goto next
    ((zero? skip) (mark lst '🔫)) ;; all skipped ? kill
    (else (mark lst '😥 )  ;; relieved face
           (kill (cdr lst ) (1- skip))))) ;; skip 1 and goto next
