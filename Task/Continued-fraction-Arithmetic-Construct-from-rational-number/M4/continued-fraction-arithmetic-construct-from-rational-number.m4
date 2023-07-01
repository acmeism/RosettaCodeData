divert(-1)

# m4 is a recursive macro language with eager evaluation.  Generally
# there is no tail-call optimization. I shall define r2cf in a natural
# way, rather than try to mimic call-by-reference or lazy evaluation.

define(`r2cf',`$1/$2 => [_$0($1,$2,`')]')
define(`_r2cf',
  `ifelse(eval($2 != 0),1,
    `$3eval($1 / $2)$0($2,eval($1 % $2),ifelse($3,,`; ',```,'' '))')')

divert`'dnl
dnl
r2cf(1, 2)
r2cf(3, 1)
r2cf(23, 8)
r2cf(13, 11)
r2cf(22, 7)
r2cf(-151, 77)
dnl
r2cf(14142, 10000)
r2cf(141421, 100000)
r2cf(1414214, 1000000)
r2cf(14142136, 10000000)
dnl
r2cf(31, 10)
r2cf(314, 100)
r2cf(3142, 1000)
r2cf(31428, 10000)
r2cf(314285, 100000)
r2cf(3142857, 1000000)
r2cf(31428571, 10000000)
r2cf(314285714, 100000000)
