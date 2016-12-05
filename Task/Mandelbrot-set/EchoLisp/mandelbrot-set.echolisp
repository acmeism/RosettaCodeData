(lib 'math) ;; fractal function
(lib 'plot)

;; (fractal z zc n) iterates z := z^2 + c, n times
;; 100 iterations
(define (mset z) (if (= Infinity (fractal 0 z 100)) Infinity z))

;; plot function argument inside square (-2 -2), (2,2)
(plot-z-arg mset -2 -2)

;; result here [http://www.echolalie.org/echolisp/help.html#fractal]
