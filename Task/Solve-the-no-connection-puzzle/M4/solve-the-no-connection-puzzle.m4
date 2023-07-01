divert(-1)

define(`abs',`eval(((( $1 ) < 0) * (-( $1 ))) + ((0 <= ( $1 )) * ( $1 )))')

define(`display_solution',
`    substr($1,0,1)   substr($1,1,1)
   /|\ /|\
  / | X | \
 /  |/ \|  \
substr($1,2,1)`---'substr($1,3,1)`---'substr($1,4,1)`---'substr($1,5,1)
 \  |\ /|  /
  \ | X | /
   \|/ \|/
    substr($1,6,1)   substr($1,7,1)')

define(`satisfies_constraints',
`eval(satisfies_no_duplicates_constraint($1) && satisfies_difference_constraints($1))')

define(`satisfies_no_duplicates_constraint',
`eval(index(all_but_last($1),last($1)) == -1)')

define(`satisfies_difference_constraints',
`pushdef(`A',ifelse(eval(1 <= len($1)),1,substr($1,0,1),100))`'dnl
pushdef(`B',ifelse(eval(2 <= len($1)),1,substr($1,1,1),200))`'dnl
pushdef(`C',ifelse(eval(3 <= len($1)),1,substr($1,2,1),300))`'dnl
pushdef(`D',ifelse(eval(4 <= len($1)),1,substr($1,3,1),400))`'dnl
pushdef(`E',ifelse(eval(5 <= len($1)),1,substr($1,4,1),500))`'dnl
pushdef(`F',ifelse(eval(6 <= len($1)),1,substr($1,5,1),600))`'dnl
pushdef(`G',ifelse(eval(7 <= len($1)),1,substr($1,6,1),700))`'dnl
pushdef(`H',ifelse(eval(8 <= len($1)),1,substr($1,7,1),800))`'dnl
eval(1 < abs((A) - (C)) &&
     1 < abs((A) - (D)) &&
     1 < abs((A) - (E)) &&
     1 < abs((C) - (G)) &&
     1 < abs((D) - (G)) &&
     1 < abs((E) - (G)) &&
     1 < abs((B) - (D)) &&
     1 < abs((B) - (E)) &&
     1 < abs((B) - (F)) &&
     1 < abs((D) - (H)) &&
     1 < abs((E) - (H)) &&
     1 < abs((F) - (H)) &&
     1 < abs((C) - (D)) &&
     1 < abs((D) - (E)) &&
     1 < abs((E) - (F)))'`dnl
popdef(`A',`B',`C',`D',`E',`F',`G',`H')')

define(`all_but_last',`substr($1,0,decr(len($1)))')
define(`last',`substr($1,decr(len($1)))')

define(`last_is_eight',`eval((last($1)) == 8)')
define(`strip_eights',`ifelse(last_is_eight($1),1,`$0(all_but_last($1))',`$1')')

define(`incr_last',`all_but_last($1)`'incr(last($1))')

define(`solve_puzzle',`_$0(1)')
define(`_solve_puzzle',
`ifelse(eval(len($1) == 8 && satisfies_constraints($1)),1,`display_solution($1)',
        satisfies_constraints($1),1,`$0($1`'1)',
        last_is_eight($1),1,`$0(incr_last(strip_eights($1)))',
        `$0(incr_last($1))')')

divert`'dnl
dnl
solve_puzzle
