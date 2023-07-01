(lib 'matrix) ;; the matrix library provides LU-decomposition
(decimals 5)

(define A (list->array' (1 3 5 2 4 7 1 1 0 ) 3 3))
(define PLU (matrix-lu-decompose A)) ;; -> list of three matrices, P, Lower, Upper

(array-print (first PLU))
0  1  0
1  0  0
0  0  1
(array-print (second PLU))
1    0   0
0.5  1   0
0.5  -1  1
(array-print (caddr PLU))
2  4  7
0  1  1.5
0  0  -2

(define A (list->array '(11 9 24 2 1 5 2 6 3 17 18 1 2 5 7 1 ) 4 4))
(define PLU (matrix-lu-decompose A)) ;; -> list of three matrices, P, Lower, Upper
(array-print (first PLU))
1  0  0  0
0  0  1  0
0  1  0  0
0  0  0  1

(array-print (second PLU))
1        0        0       0
0.27273  1        0       0
0.09091  0.2875   1       0
0.18182  0.23125  0.0036  1

(array-print (caddr PLU))
11  9         24        2
0   14.54545  11.45455  0.45455
0   0         -3.475    5.6875
0   0         0         0.51079
