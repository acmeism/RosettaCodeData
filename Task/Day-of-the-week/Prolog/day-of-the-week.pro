main() :-
    christmas_days_falling_on_sunday(2011, 2121, SundayList),
    writeln(SundayList).

christmas_days_falling_on_sunday(StartYear, EndYear, SundayList) :-
    numlist(StartYear, EndYear, YearRangeList),
    include(is_christmas_day_a_sunday, YearRangeList, SundayList).

is_christmas_day_a_sunday(Year) :-
    Date = date(Year, 12, 25),
    day_of_the_week(Date, DayOfTheWeek),
    DayOfTheWeek == 7.
