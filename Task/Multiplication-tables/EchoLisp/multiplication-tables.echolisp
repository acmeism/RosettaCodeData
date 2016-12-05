(lib 'matrix)

(define (mtable i j)
    (cond
    ((and (zero? i) (zero? j)) "😅")
    ((= i 0) j)
    ((= j 0) i)
    ((>= j i ) (* i j ))
    (else " ")))

(array-print (build-array 13 13 mtable))
