: next-random dup * 1000 / 1000000 mod ;
: 5-random-num 5 0 do next-random dup . loop ;
675248 5-random-num
