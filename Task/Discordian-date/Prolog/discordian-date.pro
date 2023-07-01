% See https://en.wikipedia.org/wiki/Discordian_calendar

main:-
    test(2022, 4, 20),
    test(2020, 5, 24),
    test(2020, 2, 29),
    test(2019, 7, 15),
    test(2025, 3, 19),
    test(2017, 12, 8).

test(Gregorian_year, Gregorian_month, Gregorian_day):-
    ddate(Gregorian_year, Gregorian_month, Gregorian_day,
          Discordian_date),
    format('~|~`0t~d~2+-~|~`0t~d~2+-~|~`0t~d~2+: ~w~n', [Gregorian_year,
           Gregorian_month, Gregorian_day, Discordian_date]).

ddate(Gregorian_year, 2, 29, Discordian_date):-
    convert_year(Gregorian_year, Discordian_year),
    swritef(Discordian_date, 'St. Tib\'s Day in the YOLD %w',
            [Discordian_year]),
    !.
ddate(Gregorian_year, Gregorian_month, Gregorian_day,
      Discordian_date):-
    convert_year(Gregorian_year, Discordian_year),
    day_of_year(Gregorian_month, Gregorian_day, Daynum),
    Season is Daynum//73,
    Weekday is Daynum mod 5,
    Day_of_season is 1 + Daynum mod 73,
    season(Season, Season_name),
    week_day(Weekday, Day_name),
    (holy_day(Season, Day_of_season, Holy_day) ->
        swritef(Discordian_date, '%w, day %w of %w in the YOLD %w. Celebrate %w!',
                [Day_name, Day_of_season, Season_name, Discordian_year, Holy_day])
        ;
        swritef(Discordian_date, '%w, day %w of %w in the YOLD %w',
                [Day_name, Day_of_season, Season_name, Discordian_year])
    ).

convert_year(Gregorian_year, Discordian_year):-
    Discordian_year is Gregorian_year + 1166.

day_of_year(M, D, N):-
    month_days(M, Days),
    N is Days + D - 1.

month_days(1, 0).
month_days(2, 31).
month_days(3, 59).
month_days(4, 90).
month_days(5, 120).
month_days(6, 151).
month_days(7, 181).
month_days(8, 212).
month_days(9, 243).
month_days(10, 273).
month_days(11, 304).
month_days(12, 334).

season(0, 'Chaos').
season(1, 'Discord').
season(2, 'Confusion').
season(3, 'Bureacracy').
season(4, 'The Aftermath').

week_day(0, 'Sweetmorn').
week_day(1, 'Boomtime').
week_day(2, 'Pungenday').
week_day(3, 'Prickle-Prickle').
week_day(4, 'Setting Orange').

holy_day(0, 5, 'Mungday').
holy_day(0, 50, 'Chaoflux').
holy_day(1, 5, 'Mojoday').
holy_day(1, 50, 'Discoflux').
holy_day(2, 5, 'Syaday').
holy_day(2, 50, 'Confuflux').
holy_day(3, 5, 'Zaraday').
holy_day(3, 50, 'Bureflux').
holy_day(4, 5, 'Maladay').
holy_day(4, 50, 'Afflux').
