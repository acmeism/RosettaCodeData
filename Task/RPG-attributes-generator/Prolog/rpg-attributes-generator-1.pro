generate_stat(Stat) :-
    length(DiceRolls, 4),
    maplist(random_between(1, 6), DiceRolls),
    sum_list(DiceRolls, Sum),
    min_list(DiceRolls, Min),
    Stat is Sum - Min.

generate_stats(Stats) :-
    once((repeat,
        length(Stats, 6),
        maplist(generate_stat, Stats),
        sum_list(Stats, Total),
        Total >= 75,
        aggregate_all(count, ( member(Stat, Stats), Stat > 15 ), Count),
        Count >= 2
    )).
