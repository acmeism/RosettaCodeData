%%  Here is a one-liner version for education
%%  Elegant once you lean on list comprehensions and library functions.
%%  Below is a true one-liner (single expression) that computes all solutions for n < 1000.
%%
io:format("~p~n", [[ N || N <- lists:seq(0,999), string:find(integer_to_list(N),
                  integer_to_list(lists:sum([D-$0 || D <- integer_to_list(N)]))) =/= nomatch ]]).
