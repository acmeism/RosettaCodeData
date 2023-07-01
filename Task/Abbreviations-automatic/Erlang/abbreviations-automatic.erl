-module(abbreviateweekdays).
-export([ main/0 ]).


uniq(L,Acc) ->
    io:fwrite("Min = ~p",[Acc]),
    io:fwrite(" Abbr:~p~n",[ sets:to_list(L) ]).

uniq(_, L, Acc) ->
    Abbr = [string:substr(X,1,Acc) || X <- L],
    %  list of abbrevs, starting with substring 1,1:
    TempSet = sets:from_list( Abbr ),
    TempSize = sets:size(TempSet),
    if
      TempSize =:= 7 ->
        uniq(TempSet,Acc);
      true  -> uniq(0, L, Acc+1)
     end.

read_lines(Device, Acc) when Acc < 19 ->
   case file:read_line(Device) of
    {ok, Line} ->
      Tokenized = string:tokens(Line," "),
      uniq(0,Tokenized,1),
      read_lines(Device, Acc + 1);
     eof ->
       io:fwrite("~p~n",["Done"])
    end;

read_lines(Device, 19) ->
       io:fwrite("~p~n",["Done"]).


main() ->
  {ok, Device} = (file:open("weekdays.txt", read)),
  read_lines(Device, 1).
