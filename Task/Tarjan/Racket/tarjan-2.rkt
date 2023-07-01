#lang racket

(require graph)

(define g (unweighted-graph/adj '([0 1]
                                  [2 0]
                                  [5 2 6]
                                  [6 5]
                                  [1 2]
                                  [3 1 2 4]
                                  [4 5 3]
                                  [7 4 7 6])))

(scc g)
