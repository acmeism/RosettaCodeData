display_date :-
    get_time(Time),
    format_time(atom(Short), '%Y-%M-%d',      Time),
    format_time(atom(Long),  '%A, %B %d, %Y', Time),
    format('~w~n~w~n', [Short, Long]).
