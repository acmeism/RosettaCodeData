-module(gapful_demo).
-mode(compile).

report_range([Start, Size]) ->
 io:fwrite("The first ~w gapful numbers >= ~w:~n~w~n~n", [Size, Start,
  stream:to_list(stream:take(Size, stream:filter(fun gapful:is_gapful/1,
  stream:naturals(Start))))]).

main(_) -> lists:map(fun report_range/1, [[1,30],[1000000,15],[1000000000,10]]).
