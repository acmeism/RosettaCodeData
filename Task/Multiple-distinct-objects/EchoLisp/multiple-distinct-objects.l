;; wrong - make-vector is evaluated one time - same vector

(define L (make-list 3 (make-vector 4)))
L    → (#(0 0 0 0) #(0 0 0 0) #(0 0 0 0))
(vector-set! (first L ) 1 '🔴) ;; sets the 'first' vector

L   → (#(0 🔴 0 0) #(0 🔴 0 0) #(0 🔴 0 0))

;; right - three different vectors

(define L(map make-vector (make-list 3 4)))
L    → (#(0 0 0 0) #(0 0 0 0) #(0 0 0 0))
(vector-set! (first L ) 1 '🔵) ;; sets the first vector

L   → (#(0 🔵 0 0) #(0 0 0 0) #(0 0 0 0)) ;; OK
