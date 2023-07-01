divert(-1)

# I assume non-negative arguments. The algorithm is described at
# https://en.wikipedia.org/w/index.php?title=Extended_Euclidean_algorithm&oldid=1135569411#Modular_integers

define(`inverse',`_$0(eval(`$1'), eval(`$2'))')
define(`_inverse',`_$0($2, 0, 1, $2, $1)')
define(`__inverse',
`dnl  n = $1,  t = $2,  newt = $3,  r = $4,  newr = $5
ifelse(eval($5 != 0), 1, `$0($1, $3,
                             eval($2 - (($4 / $5) * $3)),
                             $5,eval($4 % $5))',
       eval($4 > 1), 1, `no inverse',
       eval($2 < 0), 1, eval($2 + $1),
       $2)')

divert`'dnl
inverse(42, 2017)
