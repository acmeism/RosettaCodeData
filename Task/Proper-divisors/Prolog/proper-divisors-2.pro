?- show_proper_divisors_of_range(1,10).
2:[1]
3:[1]
4:[1,2]
5:[1]
6:[1,2,3]
7:[1]
8:[1,2,4]
9:[1,3]
10:[1,2,5]
true.

?- find_most_proper_divisors_in_range(1,20000,Result).
Result = num(15120)-divisor_count(79).
