main() :-
    weekends(1900, 2100, FiveWeekendList, RemainderWeekendList),

    length(FiveWeekendList, FiveLen),
    maplist(write, ["Total five weekend months:", FiveLen, '\n']),

    slice(FiveWeekendList, 5, FirstFiveList),
    maplist(write, ["First five {year,month} pairs:", FirstFiveList, '\n']),

    slice(FiveWeekendList, -5, LastFiveList),
    maplist(write, ["Last five {year,month} pairs:", LastFiveList, '\n']),

    maplist(take_year, FiveWeekendList, FiveYearList),
    list_to_set(FiveYearList, FiveYearSet),

    maplist(take_year, RemainderWeekendList, RemainderYearList),
    list_to_set(RemainderYearList, RemainderYearSet),

    subtract(RemainderYearSet, FiveYearSet, NonFiveWeekendSet),
    length(NonFiveWeekendSet, NonFiveWeekendLen),

    maplist(write, ["Total years with no five weekend months:", NonFiveWeekendLen, '\n']),
    writeln(NonFiveWeekendSet).

weekends(StartYear, EndYear, FiveWeekendList, RemainderWeekendList) :-
    numlist(StartYear, EndYear, YearList),
    numlist(1, 12, MonthList),
    pair(YearList, MonthList, YearMonthList),
    partition(has_five_weekends, YearMonthList, FiveWeekendList, RemainderWeekendList).

has_five_weekends({Year, Month}) :-
    long_month(Month),
    starts_on_a_friday(Year, Month).

starts_on_a_friday(Year, Month) :-
    Date = date(Year, Month, 1),
    day_of_the_week(Date, DayOfTheWeek),
    DayOfTheWeek == 5.

take_year({Year, _}, Year).

long_month(1).
long_month(3).
long_month(5).
long_month(7).
long_month(8).
long_month(10).
long_month(12).

% Helpers

% https://stackoverflow.com/a/7739806
pair(L1, L2, Pairs):-findall({A,B}, (member(A, L1), member(B, L2)), Pairs).

slice(_, 0, []).

slice(List, N, NList):-
    N < 0,
    N1 is abs(N),
    last_n_elements(List, N1, NList).

slice(List, N, NList):-
    N > 0,
    first_n_elements(List, N, NList).

first_n_elements(List, N, FirstN):-
    length(FirstN, N),
    append(FirstN, _, List).

last_n_elements(List, N, LastN) :-
    length(LastN, N),
    append(_, LastN, List).
