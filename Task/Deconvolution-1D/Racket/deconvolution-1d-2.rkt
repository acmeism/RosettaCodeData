(define f (col-matrix [-3 -6 -1 8 -6 3 -1 -9 -9 3 -2 5 2 -2 -7 -1]))
(define h (col-matrix [-8 -9 -3 -1 -6 7]))
(define g (col-matrix [24 75 71 -34 3 22 -45 23 245 25 52 25 -67 -96 96 31 55 36 29 -43 -7]))

(deconvolve g f)
(deconvolve g h)
