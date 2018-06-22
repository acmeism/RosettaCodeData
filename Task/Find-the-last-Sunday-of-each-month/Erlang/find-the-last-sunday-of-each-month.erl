-module(last_sundays).

-export([in_year/1]).

% calculate all the last sundays in a particular year
in_year(Year) ->
    [lastday(Year, Month, 7) || Month <- lists:seq(1, 12)].

% calculate the date of the last occurrence of a particular weekday
lastday(Year, Month, WeekDay) ->
    Ldm = calendar:last_day_of_the_month(Year, Month),
    Diff = calendar:day_of_the_week(Year, Month, Ldm) rem WeekDay,
    {Year, Month, Ldm - Diff}.
