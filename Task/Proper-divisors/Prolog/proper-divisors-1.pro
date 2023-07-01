divisor(N, Divisor) :-
    UpperBound is round(sqrt(N)),
    between(1, UpperBound, D),
    0 is N mod D,
    (
        Divisor = D
     ;
        LargerDivisor is N/D,
        LargerDivisor =\= D,
        Divisor = LargerDivisor
    ).

proper_divisor(N, D) :-
    divisor(N, D),
    D =\= N.


%% Task 1
%

proper_divisors(N, Ds) :-
    setof(D, proper_divisor(N, D), Ds).


%% Task 2
%

show_proper_divisors_of_range(Low, High) :-
    findall( N:Ds,
             ( between(Low, High, N),
               proper_divisors(N, Ds) ),
             Results ),
    maplist(writeln, Results).


%% Task 3
%

proper_divisor_count(N, Count) :-
    proper_divisors(N, Ds),
    length(Ds, Count).

find_most_proper_divisors_in_range(Low, High, Result) :-
    aggregate_all( max(Count, N),
                   ( between(Low, High, N),
                     proper_divisor_count(N, Count) ),
                   max(MaxCount, Num) ),
    Result = (num(Num)-divisor_count(MaxCount)).
