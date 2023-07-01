-module(tasks).
-export([main/0]).
-import(lists, [map/2, member/2, sort/1, sum/1]).

is_happy(X, XS) ->
    if
	X == 1 ->
	    true;
	X < 1 ->
	    false;
	true ->
	    case member(X, XS) of
		true -> false;
		false ->
		    is_happy(sum(map(fun(Z) -> Z*Z end,
				     [Y - 48 || Y <- integer_to_list(X)])),
			     [X|XS])
	    end
    end.

main(X, XS) ->
    if
	length(XS) == 8 ->
	    io:format("8 Happy Numbers: ~w~n", [sort(XS)]);
	true ->
	    case is_happy(X, []) of
		true -> main(X + 1, [X|XS]);
		false -> main(X + 1, XS)
	    end
    end.
main() ->
    main(0, []).
