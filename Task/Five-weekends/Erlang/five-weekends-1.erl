#!/usr/bin/env escript
%%
%% Calculate number of months with five weekends between years 1900-2100
%%
main(_) ->
  Years = [ [{Y,M} || M <- lists:seq(1,12)] || Y <- lists:seq(1900,2100) ],
  {CountedYears, {Has5W, TotM5W}} = lists:mapfoldl(
    fun(Months, {Has5W, Tot}) ->
      WithFive = [M || M <- Months, has_five(M)],
      CountM5W = length(WithFive),
      {{Months,CountM5W}, {Has5W++WithFive, Tot+CountM5W}}
    end, {[], 0}, Years),
  io:format("There are ~p months with five full weekends.~n"
            "Showing top and bottom 5:~n",
    [TotM5W]),
  lists:map(fun({Y,M}) -> io:format("~p-~p~n", [Y,M]) end,
    lists:sublist(Has5W,1,5) ++ lists:nthtail(TotM5W-5, Has5W)),
  No5W = [Y || {[{Y,_M}|_], 0} <- CountedYears],
  io:format("The following ~p years do NOT have any five-weekend months:~n",
    [length(No5W)]),
  lists:map(fun(Y) -> io:format("~p~n", [Y]) end, No5W).

has_five({Year, Month}) ->
  has_five({Year, Month}, calendar:last_day_of_the_month(Year, Month)).

has_five({Year, Month}, Days) when Days =:= 31 ->
  calendar:day_of_the_week({Year, Month, 1}) =:= 5;
has_five({_Year, _Month}, _DaysNot31) ->
  false.
