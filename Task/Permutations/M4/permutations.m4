divert(-1)

# 1-based indexing of a string's characters.
define(`get',`substr(`$1',decr(`$2'),1)')
define(`set',`substr(`$1',0,decr(`$2'))`'$3`'substr(`$1',`$2')')
define(`swap',
`pushdef(`_u',`get(`$1',`$2')')`'dnl
pushdef(`_v',`get(`$1',`$3')')`'dnl
set(set(`$1',`$2',_v),`$3',_u)`'dnl
popdef(`_u',`_v')')

# $1-fold repetition of $2.
define(`repeat',`ifelse($1,0,`',`$2`'$0(decr($1),`$2')')')

#
# Heap's algorithm. Algorithm 2 in Robert Sedgewick, 1977. Permutation
# generation methods. ACM Comput. Surv. 9, 2 (June 1977), 137-164.
#
# This implementation permutes the characters in a string of length no
# more than 9. On longer strings, it may strain the resources of a
# very old implementation of m4.
#
define(`permutations',
    `ifelse($2,`',`$1
$0(`$1',repeat(len(`$1'),1),2)',
        `ifelse(eval(($3) <= len(`$1')),1,
             `ifelse(eval(get($2,$3) < $3),1,
                       `swap(`$1',_$0($2,$3),$3)
$0(swap(`$1',_$0($2,$3),$3),set($2,$3,incr(get($2,$3))),2)',
                       `$0(`$1',set($2,$3,1),incr($3))')')')')
define(`_permutations',`eval((($2) % 2) + ((1 - (($2) % 2)) * get($1,$2)))')

divert`'dnl
permutations(`123')
permutations(`abcd')
