fusc_term =: ({~ -:@#)`([: +/ ({~ ([: -: _1 1 + #)))@.(2 | #)
fusc =: (, fusc_term)@:]^:[ 0 1"_

   NB. show the first 61 fusc numbers (starting at zero) in a horizontal format.
   61 {. fusc 70
0 1 1 2 1 3 2 3 1 4 3 5 2 5 3 4 1 5 4 7 3 8 5 7 2 7 5 8 3 7 4 5 1 6 5 9 4 11 7 10 3 11 8 13 5 12 7 9 2 9 7 12 5 13 8 11 3 10 7 11 4

   9!:17]2 2 NB. specify bottom right position in box

   FUSC =: fusc 99999
   DIGITS =: ; ([: # 10&#.inv)&.> FUSC

   (;: 'index value') ,. <"0(,: {&A) DIGITS i. 1 2 3 4
┌─────┬─┬──┬────┬─────┐
│index│0│37│1173│35499│
├─────┼─┼──┼────┼─────┤
│value│0│11│ 108│ 1076│
└─────┴─┴──┴────┴─────┘
