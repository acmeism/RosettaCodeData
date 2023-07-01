main:
    { [2 3 5 7 11 13]
    ar2ls dup cp
    <- sum_stack ->
    prod_stack
    %d cr <<
    %d cr << }

sum_stack:
    { { give
        { + }
        { depth 1 > }
    do_while } nest }

prod_stack:
    { { give
        { * }
        { depth 1 > }
    do_while } nest }
