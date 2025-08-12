:- use_module(library(aggregate)).
:- use_module(library(lists)).
:- use_module(library(random)).

random_subset(Length, List, Subset) :-
    random_permutation(List, Shuffled),
    length(Subset, Length),
    prefix(Subset, Shuffled).

random_play :-
    numlist(1, 100, Prisoners),
    random_permutation(Prisoners, Drawers),
    forall(member(Prisoner, Prisoners), (
        random_subset(50, Drawers, CheckedDrawers),
        memberchk(Prisoner, CheckedDrawers)
    )).

optimal_play :-
    numlist(1, 100, Prisoners),
    random_permutation(Prisoners, Drawers),
    forall(member(Prisoner, Prisoners), optimal_play(50, Prisoner, Prisoner, Drawers)).

optimal_play(ChecksRemaining, Prisoner, NumberToCheck, Drawers) :-
    ChecksRemaining > 0,
    nth1(NumberToCheck, Drawers, NumberInDrawer),
    (   NumberInDrawer = Prisoner
    ->  true
    ;   ChecksRemaining0 is ChecksRemaining - 1,
        optimal_play(ChecksRemaining0, Prisoner, NumberInDrawer, Drawers)
    ).

:- meta_predicate play_n_times(+, 0, -).
play_n_times(PlayCount, Play, Percentage) :-
    aggregate_all(count, ( between(1, PlayCount, _), call(Play) ), Victories),
    Percentage is Victories / PlayCount * 100.

main(SimulationCount) :-
    play_n_times(SimulationCount, random_play, RandomPlayPercent),
    play_n_times(SimulationCount, optimal_play, OptimalPlayPercent),
    format("Simulation count: ~d\nRandom play wins: ~f% of the simulations.\nOptimal play wins ~f% of the simulations.",
        [SimulationCount, RandomPlayPercent, OptimalPlayPercent]).

:- main(100_000).
