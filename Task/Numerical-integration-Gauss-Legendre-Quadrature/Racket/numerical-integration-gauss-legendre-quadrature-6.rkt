> (require plot)
> (parameterize ([plot-x-label "Number of Gaussian nodes"]
                 [plot-y-label "Integration error"]
                 [plot-y-transform log-transform]
                 [plot-y-ticks (log-ticks #:base 10)])
    (plot (points (for/list ([n (in-range 2 11)])
                    (list n (abs (- (integrate exp -3 3 #:nodes n)
                                    (- (exp 3) (exp -3)))))))))
