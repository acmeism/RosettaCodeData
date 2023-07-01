combinations_of_length(_,[]).
combinations_of_length([X|T],[X|Combinations]):-
    combinations_of_length([X|T],Combinations).
combinations_of_length([_|T],[X|Combinations]):-
    combinations_of_length(T,[X|Combinations]).
