create test 1 , 2 , 3 , 2 , 6 , 4 , 5 , 3 , 6 ,
here test - cell / constant ntest
: .test ( n -- ) 0 ?do test i cells + ? loop ;

test ntest 2dup cell-sort uniq .test
