define(`extractdec', `ifelse(eval(`$1%100 < 10'),1,`0',`')eval($1%100)')dnl
define(`fmean', `eval(`($2/$1)/100').extractdec(eval(`$2/$1'))')dnl
define(`mean', `rmean(`$#', $@)')dnl
define(`rmean', `ifelse(`$3', `', `fmean($1,$2)',dnl
`rmean($1, eval($2+$3), shift(shift(shift($@))))')')dnl
