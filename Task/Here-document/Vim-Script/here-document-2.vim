let d58 = "5 6 7 8"
let d =<< eval DOZEN
  1 2 3 4 {d58}
  9 10 11 12
DOZEN
call append(line('$'), d)
