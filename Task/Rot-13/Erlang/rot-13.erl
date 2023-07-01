rot13(Str) ->
    F = fun(C) when (C >= $A andalso C =< $M); (C >= $a andalso C =< $m) -> C + 13;
           (C) when (C >= $N andalso C =< $Z); (C >= $n andalso C =< $z) -> C - 13;
           (C) -> C
        end,
    lists:map(F, Str).
