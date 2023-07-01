-module(compare_strings).

-export([all_equal/1,all_incr/1]).

all_equal(Strings) ->
	all_fulfill(fun(S1,S2) -> S1 == S2 end,Strings).

all_incr(Strings) ->
	all_fulfill(fun(S1,S2) -> S1 < S2 end,Strings).

all_fulfill(Fun,Strings) ->
	lists:all(fun(X) -> X end,lists:zipwith(Fun, lists:droplast(Strings), tl(Strings)) ).
