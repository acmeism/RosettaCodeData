; [372x17] * [17x372]
(define M 372)
(define N 17)

; [0 1 2 ... 371]
; [1 2 3 ... 372]
; [2 3 4 ... 373]
; ...
; [16 17 ... 387]
(define A (map (lambda (i)
                  (iota M i))
            (iota N)))

; [0 1 2 ... 16]
; [1 2 3 ... 17]
; [2 3 4 ... 18]
; ...
; [371 372 ... 387]
(define B (map (lambda (i)
                  (iota N i))
            (iota M)))

(for-each print (matrix-multiply A B))
