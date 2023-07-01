-module(five_weekends).

-export([report/0, print_5w_month/1, print_year_with_no_5w_month/1]).

report() ->
  Years = make_nested_period_list(1900, 2100),
  {CountedYears, {All5WMonths, CountOf5WMonths}} = lists:mapfoldl(
    fun(SingleYearSublist, {All5WMonths, CountOf5WMonths}) ->
      MonthsWith5W = [Month || Month <- SingleYearSublist, if_has_5w(Month)],
      CountOf5WMonthsFor1Year = length(MonthsWith5W),
      { % Result of map for this year sublist:
        {SingleYearSublist,CountOf5WMonthsFor1Year},
        % Accumulate total result for our fold:
        {All5WMonths ++ MonthsWith5W, CountOf5WMonths + CountOf5WMonthsFor1Year}
      }
    end, {[], 0}, Years),
  io:format("There are ~p months with five full weekends.~n"
            "Showing top and bottom 5:~n",
    [CountOf5WMonths]),
  lists:map(fun print_5w_month/1, take_nth_first_and_last(5, All5WMonths)),
  YearsWithout5WMonths = find_years_without_5w_months(CountedYears),
  io:format("The following ~p years do NOT have any five-weekend months:~n",
            [length(YearsWithout5WMonths)]),
  lists:map(fun print_year_with_no_5w_month/1, YearsWithout5WMonths).

make_nested_period_list(FromYear, ToYear) ->
  [ make_monthtuple_sublist_for_year(Year) || Year <- lists:seq(FromYear, ToYear) ].

make_monthtuple_sublist_for_year(Year) ->
  [ {Year, Month} || Month <- lists:seq(1,12) ].

if_has_5w({Year, Month}) ->
  if_has_5w({Year, Month}, calendar:last_day_of_the_month(Year, Month)).

if_has_5w({Year, Month}, Days) when Days =:= 31 ->
  calendar:day_of_the_week({Year, Month, 1}) =:= 5;
if_has_5w({_Year, _Month}, _DaysNot31) ->
  false.

print_5w_month({Year, Month}) ->
  io:format("~p-~p~n", [Year, Month]).

print_year_with_no_5w_month(Year) ->
  io:format("~p~n", [Year]).

take_nth_first_and_last(N, List) ->
  Len = length(List),
  lists:sublist(List, 1, N) ++ lists:nthtail(Len - N, List).

find_years_without_5w_months(List) ->
  [Y || {[{Y,_M}|_], 0} <- List].
