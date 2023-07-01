#! /usr/bin/escript

-define(LOG2E, 1.44269504088896340735992).

main(_) ->
    Self = escript:script_name(),
    {ok, Contents} = file:read_file(Self),
    io:format("My entropy is ~p~n", [entropy(Contents)]).

entropy(Data) ->
    Frq = count(Data),
    maps:fold(fun(_, C, E) ->
                  P = C / byte_size(Data),
                  E - P*math:log(P)
              end, 0, Frq) * ?LOG2E.

count(Data) -> count(Data, 0, #{}).
count(Data, I, Frq) when I =:= byte_size(Data) -> Frq;
count(Data, I, Frq) ->
    Chr = binary:at(Data, I),
    case Frq of
        #{Chr := K} -> count(Data, I+1, Frq #{Chr := K+1});
        _ -> count(Data, I+1, Frq #{Chr => 1})
    end.
