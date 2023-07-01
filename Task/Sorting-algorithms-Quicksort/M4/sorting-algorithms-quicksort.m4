dnl  return the first element of a list when called in the funny way seen below
define(`arg1', `$1')dnl
dnl
dnl  append lists 1 and 2
define(`append',
   `ifelse(`$1',`()',
      `$2',
      `ifelse(`$2',`()',
         `$1',
         `substr($1,0,decr(len($1))),substr($2,1)')')')dnl
dnl
dnl  separate list 2 based on pivot 1, appending to left 3 and right 4,
dnl  until 2 is empty, and then combine the sort of left with pivot with
dnl  sort of right
define(`sep',
   `ifelse(`$2', `()',
      `append(append(quicksort($3),($1)),quicksort($4))',
      `ifelse(eval(arg1$2<=$1),1,
         `sep($1,(shift$2),append($3,(arg1$2)),$4)',
         `sep($1,(shift$2),$3,append($4,(arg1$2)))')')')dnl
dnl
dnl  pick first element of list 1 as pivot and separate based on that
define(`quicksort',
   `ifelse(`$1', `()',
      `()',
      `sep(arg1$1,(shift$1),`()',`()')')')dnl
dnl
quicksort((3,1,4,1,5,9))
