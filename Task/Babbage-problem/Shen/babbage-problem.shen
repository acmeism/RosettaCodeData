(define babbage
    N -> N where (= 269696 (shen.mod (* N N) 1000000)))
    N -> (babbage (+ N 1))

(babbage 1)
