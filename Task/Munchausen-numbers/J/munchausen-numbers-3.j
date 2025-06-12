   load 'stats/base/combinatorial'
   nDigits =: 4
   p =: 0 1 4 27 256 3125 46656 823543 16777216 387420489
   sp =: [:+/"1 p{~]
   dg =: 10&#.inv
   (sp@#~[:-:/"2[:/:~"1(],:~dg@sp)"1) nDigits combrep 10
0 1 3435
