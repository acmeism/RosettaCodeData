-mode(compile).
-import(lists, [foldl/3]).

main(_) ->
   {ok, Tmat} = file:open("triangle.txt", [read, raw, {read_ahead, 16384}]),
   Max = max_sum(Tmat, []),
   io:format("The maximum total is ~b~n", [Max]).

max_sum(FD, Last) ->
    case file:read_line(FD) of
        eof -> foldl(fun erlang:max/2, 0, Last);
        {ok, Line} ->
            Current = [binary_to_integer(B) || B <- re:split(Line, "[ \n]"), byte_size(B) > 0],
            max_sum(FD, fold_row(Last, Current))
    end.

% The first argument has one more element than the second, so compute
% the initial sum so that both lists have identical length for fold_rest().
fold_row([], L) -> L;
fold_row([A|_] = Last, [B|Bs]) ->
    [A+B | fold_rest(Last, Bs)].

% Both lists must have same length
fold_rest([A], [B]) -> [A+B];
fold_rest([A1 | [A2|_] = As], [B|Bs]) -> [B + max(A1,A2) | fold_rest(As, Bs)].
