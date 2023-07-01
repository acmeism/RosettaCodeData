Red []

K_runs: 100000
repeat n 100 [append rand_arr: []  n]              ;; define array/series with numbers 1..100

;;-------------------------------
strat_optimal: function [pris ][
;;-------------------------------
  locker: pris                                    ;; start with locker equal to prisoner number
  loop 50 [
    if Board/:locker = pris [ return true ]       ;; locker with prisoner number found
    locker: Board/:locker
  ]
  false                                           ;; number not found - fail
]
;;-------------------------------
strat_rand: function [pris ][
;;-------------------------------
  random rand_arr                                                 ;; define set of  random lockers
  repeat n 50 [ if Board/(rand_arr/:n) = pris [ return true ]  ]  ;; try first 50, found ? then return success
  false
]

;;------------------------------
check_board: function [ strat][
;;------------------------------
repeat pris 100 [                                                   ;; for each prisoner
  either  strat = 'optimal [ unless strat_optimal pris [return false ]  ]
                            [ unless strat_rand pris [return false ]  ]
]
  true                                                  ;; all 100 prisoners passed test
]

saved: saved_rand: 0                                    ;; count all saved runs per strategy
loop K_runs [
  Board: random copy rand_arr                           ;; new board for every run
  if  check_board 'optimal [saved: saved + 1]           ;; optimal stategy
  if  check_board 'rand [saved_rand: saved_rand + 1]  ;; random strategy
]

print ["runs" k_runs newline  "Percent saved opt.strategy:" saved * 100.0 / k_runs ]
print ["Percent saved random strategy:" saved_rand * 100.0 / k_runs ]
