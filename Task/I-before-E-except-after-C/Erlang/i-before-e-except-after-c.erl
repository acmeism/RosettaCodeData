-module(cei).
-export([plaus/0,count/3]).

plaus() ->
    {ok,Words} = file:read_file("unixdict.txt"),
    Swords = string:tokens(erlang:binary_to_list(Words), "\n"),
    EiF = count(Swords,"[^c]ei",0),
    IeF = count(Swords,"[^c]ie",0),
    CeiF = count(Swords,"cei",0),
    CieF = count(Swords,"cie",0),
    if CeiF >= 2 * CieF -> P1= 'is'; true -> P1 = 'is not' end,
    if IeF >= 2 * EiF -> P2 = 'is'; true -> P2 = 'is not' end,
    if P1 == 'is' andalso p2 == 'is' -> P3 ='is'; true -> P3 = 'is not' end,
    io:format("Proposition 1. ~w plausible: ie ~w, ei ~w~n", [P2,IeF,EiF]),
    io:format("Proposition 2. ~w plausible: cei ~w, cie ~w~n", [P1,CeiF,CieF]),
    io:format("The rule ~w plausible~n", [P3]).

count(List,Pattern,Acc) when length(List) == 0 -> Acc;
count(List,Pattern,Acc) ->
    [H|T] = List,
    case re:run(H,Pattern,[global,{capture,none}]) of
        match -> count(T,Pattern, Acc + 1);
        nomatch -> count(T,Pattern, Acc)
    end.
