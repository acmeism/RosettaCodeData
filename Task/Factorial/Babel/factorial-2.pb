((main
    {(0 1 2 3 4 5 6 7 8 9 10)
    {fact ! %d nl <<}
    each})

(fact
       {({dup 0 =}{ zap 1 }
         {dup 1 =}{ zap 1 }
         {1      }{ dup 1 - fact ! *})
        cond}))
