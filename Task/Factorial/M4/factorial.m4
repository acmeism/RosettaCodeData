define(`factorial',`ifelse(`$1',0,1,`eval($1*factorial(decr($1)))')')dnl
dnl
factorial(5)
