define(`thenif', `ifelse($2, $3, `$1')')dnl
dnl
ifelse(eval(23 > 5), 1, 23 is greater than 5)
ifelse(eval(23 > 5), 0, math is broken)
thenif(23 is greater than 5, eval(23 > 5), 1)
thenif(math is broken, eval(23 > 5), 0)
