Until =: 2 :'u^:(0-:v)^:_'  NB. unused but so fun
prime_factors_of_tail =: ~.@:q:@:{:
numbers_not_in_list =: -.~ >:@:i.@:(>./)


ekg =: 3 :0                             NB. return next sequence
 if. 1 = # y do. NB. initialize
  1 , y
  return.
 end.
 a =. prime_factors_of_tail y
 b =. numbers_not_in_list y
 index_of_lowest =. {. _ ,~ I. 1 e."1 a e."1 q:b
 if. index_of_lowest < _ do. NB. if the list doesn't need extension
  y , index_of_lowest { b
  return.
 end.
 NB. otherwise extend the list
 b =. >: >./ y
 while. 1 -.@:e. a e. q: b do.
  b =. >: b
 end.
 y , b
)

   ekg^:9&>2 5 7 9 10
1  2  4 6 3 9 12  8 10  5
1  5 10 2 4 6  3  9 12  8
1  7 14 2 4 6  3  9 12  8
1  9  3 6 2 4  8 10  5 15
1 10  2 4 6 3  9 12  8 14


assert 9 -: >:Until(>&8) 2
assert (,2) -: prime_factors_of_tail 6 8  NB. (nub of)
assert 3 4 5 -: numbers_not_in_list 1 2      6
