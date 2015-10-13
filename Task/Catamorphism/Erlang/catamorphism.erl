%% @author Salvador Tamarit <tamarit27@gmail.com>

-module(catamorphism).

-export([test/0]).

test() ->
	Nums = lists:seq(1,10),
	Summation =
		lists:foldl(fun(X, Acc) -> X + Acc end, 0, Nums),
	Product =
		lists:foldl(fun(X, Acc) -> X * Acc end, 1, Nums),
	Concatenation =
		lists:foldr(
			fun(X, Acc) -> integer_to_list(X) ++ Acc end,
			"",
			Nums),
	{Summation, Product, Concatenation}.
