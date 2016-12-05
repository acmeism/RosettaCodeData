-module(holidays).
-export([task/0]).

offsets(easter)    ->  0;
offsets(ascension) -> 39;
offsets(pentecost) -> 49;
offsets(trinity)   -> 56;
offsets(corpus)    -> 60.

month(Month) ->
    element(Month, { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" } ).

easter_date(Year) ->
    A = Year rem 19,
    B = Year div 100,
    C = Year rem 100,
    D = B div 4,
    E = B rem 4,
    F = (B + 8) div 25,
    G = (B - F + 1) div 3,
    H = (19*A + B - D - G + 15) rem 30,
    I = C div 4,
    K = C rem 4,
    L = (32 + 2*E + 2*I - H - K) rem 7,
    M = (A + 11*H + 22*L) div 451,
    Numerator = H + L - 7*M + 114,
    Month = Numerator div 31,
    Day = Numerator rem 31 + 1,
    {Year, Month, Day}.

holidays() ->
    [ easter, ascension, pentecost, trinity, corpus ].

holidays(Year) ->
    io:format("~4w:", [Year]),
    Gday = calendar:date_to_gregorian_days(easter_date(Year)),
    holidays(Gday, holidays()).

holidays(_, []) ->
    io:format("~n");
holidays(Gday, [H | T]) ->
    Offset = offsets(H),
    {_Year, Month, Day} = calendar:gregorian_days_to_date(Gday + Offset),
    io:format("~6w  ~3s", [Day, month(Month)]),
    holidays(Gday, T).

title([]) ->
    io:format("~n");
title([H | T]) ->
    io:format("  ~9s", [H]),
    title(T).

task() ->
    io:format("Year:"),
    title(holidays()),
    task(400, 2100, 100),
    task(2010, 2020, 1).

task(Year, Max, _) when Year > Max ->
    io:format("~n");
task(Year, Max, Step) ->
    holidays(Year),
    task(Year+Step, Max, Step).
