divert(-1)

The following macro find one solution to the eight-queens problem:

define(`solve_eight_queens',`_$0(1)')
define(`_solve_eight_queens',
`ifelse(none_of_the_queens_attacks_the_new_one($1),1,
            `ifelse(len($1),8,`display_solution($1)',`$0($1`'1)')',
        `ifelse(last_is_eight($1),1,`$0(incr_last(strip_eights($1)))',
                `$0(incr_last($1))')')')

It works by backtracking.

Partial solutions are represented by strings. For example, queens at
a7,b3,c6 would be represented by the string "736". The first position
is the "a" file, the second is the "b" file, etc. The digit in a given
position represents the queen's rank.

When a new queen is appended to the string, it must satisfy the
following constraint:

define(`none_of_the_queens_attacks_the_new_one',
       `_$0($1,decr(len($1)))')
define(`_none_of_the_queens_attacks_the_new_one',
       `ifelse($2,0,1,
               `ifelse(two_queens_attack($1,$2,len($1)),1,0,
                       `$0($1,decr($2))')')')

The `two_queens_attack' macro, used above, reduces to `1' if the
ith and jth queens attack each other; otherwise it reduces to `0':

define(`two_queens_attack',
`pushdef(`file1',eval($2))`'dnl
pushdef(`file2',eval($3))`'dnl
pushdef(`rank1',`substr($1,decr(file1),1)')`'dnl
pushdef(`rank2',`substr($1,decr(file2),1)')`'dnl
eval((rank1) == (rank2) ||
     ((rank1) + (file1)) == ((rank2) + (file2)) ||
     ((rank1) - (file1)) == ((rank2) - (file2)))`'dnl
popdef(`file1',`file2',`rank1',`rank2')')

Here is the macro that converts the solution string to a nice display:

define(`display_solution',
`pushdef(`rule',`+----+----+----+----+----+----+----+----+')`'dnl
rule
_$0($1,8)
rule
_$0($1,7)
rule
_$0($1,6)
rule
_$0($1,5)
rule
_$0($1,4)
rule
_$0($1,3)
rule
_$0($1,2)
rule
_$0($1,1)
rule`'dnl
popdef(`rule')')
define(`_display_solution',
`ifelse(index($1,$2),0,`|  Q ',`|    ')`'dnl
ifelse(index($1,$2),1,`|  Q ',`|    ')`'dnl
ifelse(index($1,$2),2,`|  Q ',`|    ')`'dnl
ifelse(index($1,$2),3,`|  Q ',`|    ')`'dnl
ifelse(index($1,$2),4,`|  Q ',`|    ')`'dnl
ifelse(index($1,$2),5,`|  Q ',`|    ')`'dnl
ifelse(index($1,$2),6,`|  Q ',`|    ')`'dnl
ifelse(index($1,$2),7,`|  Q ',`|    ')|')

Here are some simple macros used above:

define(`last',`substr($1,decr(len($1)))')        Get the last char.
define(`drop_last',`substr($1,0,decr(len($1)))') Remove the last char.
define(`last_is_eight',`eval((last($1)) == 8)')  Is the last char "8"?
define(`strip_eights',
  `ifelse(last_is_eight($1),1,`$0(drop_last($1))',
          `$1')')           Backtrack by removing all final "8" chars.
define(`incr_last',
       `drop_last($1)`'incr(last($1))')      Increment the final char.

The macros here have been presented top-down. I believe the program
might be easier to understand were the macros presented bottom-up;
then there would be no "black boxes" (unexplained macros) as one reads
from top to bottom.

I leave such rewriting as an exercise for the reader. :)

divert`'dnl
dnl
solve_eight_queens
