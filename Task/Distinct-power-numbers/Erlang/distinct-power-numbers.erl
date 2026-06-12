%% Note: math:pow/2 returns floating-point numbers.
%%       if you want integer powers, you’ll need to write a custom power function

-module(distinct_power_numbers).
-export([main/0]).

main() ->
    Terms = [math:pow(A, B) || A <- lists:seq(2, 5), B <- lists:seq(2, 5)],
    UniqueTerms = lists:usort(Terms),
    io:format("The List: ~p~n", [UniqueTerms]),
    io:format("The number of items in the list: ~p~n", [length(UniqueTerms)]).

