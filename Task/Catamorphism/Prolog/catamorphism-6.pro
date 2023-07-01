:- begin_tests(foldr).

in([1,2,3,4,5]).

ffr(Foldy,List,Starter,AccUp) :- foldr(Foldy,List,Starter,AccUp).

test(foo_foldr_len)    :- in(L),ffr(foldy_len     , L ,  0 , R), R=5.
test(foo_foldr_add)    :- in(L),ffr(foldy_add     , L ,  0 , R), R=15.
test(foo_foldr_mult)   :- in(L),ffr(foldy_mult    , L ,  1 , R), R=120.
test(foo_foldr_build)  :- in(L),ffr(foldy_build   , L , [] , R), R=[1,2,3,4,5].
test(foo_foldr_squadd) :- in(L),ffr(foldy_squadd  , L ,  0 , R), R=507425426245.
test(foo_foldr_join)   :- in(L),ffr(foldy_join    , L , "" , R), R="1,2,3,4,5".
test(foo_foldr_expr)   :- in(L),ffr(foldy_expr(*) , L ,  1 , R), R=1*(2*(3*(4*(5*1)))).

test(foo_foldr_len_empty)    :- ffr(foldy_len     , [],  0 , R), R=0.
test(foo_foldr_add_empty)    :- ffr(foldy_add     , [],  0 , R), R=0.
test(foo_foldr_mult_empty)   :- ffr(foldy_mult    , [],  1 , R), R=1.
test(foo_foldr_build_empty)  :- ffr(foldy_build   , [], [] , R), R=[].
test(foo_foldr_squadd_empty) :- ffr(foldy_squadd  , [],  0 , R), R=0.
test(foo_foldr_join_empty)   :- ffr(foldy_join    , [], "" , R), R="".
test(foo_foldr_expr_empty)   :- ffr(foldy_expr(*) , [],  1 , R), R=1.

% library(apply) has no "foldr" so no comparison tests!

:- end_tests(foldr).


:- begin_tests(foldl).

in([1,2,3,4,5]).

ffl(Foldy,List,Starter,Result) :- foldl(Foldy,List,Starter,Result).

test(foo_foldl_len)    :- in(L),ffl(foldy_len     , L ,  0 , R), R=5.
test(foo_foldl_add)    :- in(L),ffl(foldy_add     , L,   0 , R), R=15.
test(foo_foldl_mult)   :- in(L),ffl(foldy_mult    , L,   1 , R), R=120.
test(foo_foldl_build)  :- in(L),ffl(foldy_build   , L,  [] , R), R=[5,4,3,2,1].
test(foo_foldl_squadd) :- in(L),ffl(foldy_squadd  , L,   0 , R), R=21909.
test(foo_foldl_join)   :- in(L),ffl(foldy_join    , L,  "" , R), R="5,4,3,2,1".
test(foo_foldl_expr)   :- in(L),ffl(foldy_expr(*) , L,   1 , R), R=5*(4*(3*(2*(1*1)))).

test(foo_foldl_len_empty)    :- ffl(foldy_len     , [],  0 , R), R=0.
test(foo_foldl_add_empty)    :- ffl(foldy_add     , [],  0 , R), R=0.
test(foo_foldl_mult_empty)   :- ffl(foldy_mult    , [],  1 , R), R=1.
test(foo_foldl_build_empty)  :- ffl(foldy_build   , [], [] , R), R=[].
test(foo_foldl_squadd_empty) :- ffl(foldy_squadd  , [],  0 , R), R=0.
test(foo_foldl_join_empty)   :- ffl(foldy_join    , [], "" , R), R="".
test(foo_foldl_expr_empty)   :- ffl(foldy_expr(*) , [],  1 , R), R=1.

:- end_tests(foldl).

rt :- run_tests(foldr),run_tests(foldl).
