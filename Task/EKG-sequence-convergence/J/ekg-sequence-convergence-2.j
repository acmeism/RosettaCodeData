index_of_lowest =: [: {. _ ,~ [: I. 1 e."1 prime_factors_of_tail e."1 q:@:numbers_not_in_list

g =: 3 :0                             NB. return sequence with next term appended
 a =. prime_factors_of_tail y
 (, (index_of_lowest { numbers_not_in_list)`(([: >:Until(1 e. a e. q:) [: >: >./))@.(_ = index_of_lowest)) y
)

ekg2 =: (1&,)`g@.(1<#)

assert (3 -: index_of_lowest { numbers_not_in_list)1 2 4 6

assert (ekg^:9&> -: ekg2^:9&>) 2 5 7 9 10
