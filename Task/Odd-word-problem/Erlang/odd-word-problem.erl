handle(S, false, I, O) when (((S >= $a) and (S =< $z)) or ((S >= $A) and (S =< $Z))) ->
    O(S),
    handle(I(), false, I, O);
handle(S, T, I, O) when (((S >= $a) and (S =< $z)) or ((S >= $A) and (S =< $Z))) ->
    D = handle(I(), rec, I, O),
    O(S),
    case T of true -> handle(D, T, I, O); _ -> D end;
handle(S, rec, _, _) -> S;
handle($., _, _, O) -> O($.), done;
handle(eof, _, _, _) -> done;
handle(S, T, I, O) -> O(S), handle(I(), not T, I, O).

main([]) ->
    I = fun() -> hd(io:get_chars([], 1)) end,
    O = fun(S) -> io:put_chars([S]) end,
    handle(I(), false, I, O).
