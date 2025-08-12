%!  thue_morse(+N, -TM) is det.
%   Calculates the Nth number of the Thue-Morse sequence, indexing from 0.
thue_morse(N, TM) :- TM is popcount(N) mod 2.

%!  thue_morse_list(-List) is multi.
%   Calculates progressively longer prefixes of the Thue-Morse sequence.
thue_morse_list(List) :- thue_morse_list(0, List).

thue_morse_list(N, [TM | List]) :-
    thue_morse(N, TM),
    (   List = []
    ;   N1 is N + 1, thue_morse_list(N1, List)
    ).

:- length(List, 20), once(thue_morse_list(List)), write(List).
