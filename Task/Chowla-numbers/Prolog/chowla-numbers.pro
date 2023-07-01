chowla(1, 0).
chowla(2, 0).
chowla(N, C) :-
    N > 2,
    Max is floor(sqrt(N)),
    findall(X, (between(2, Max, X), N mod X =:= 0), Xs),
    findall(Y, (member(X1, Xs), Y is N div X1, Y \= Max), Ys),
    !,
    sum_list(Xs, S1),
    sum_list(Ys, S2),
    C is S1 + S2.

prime_count(Upper, Upper, Count, Count) :-
    !.

prime_count(Lower, Upper, Add, Count) :-
    chowla(Lower, 0),
    !,
    Lower1 is Lower + 1,
    Add1 is Add + 1,
    prime_count(Lower1, Upper, Add1, Count).

prime_count(Lower, Upper, Add, Count) :-
    Lower1 is Lower + 1,
    prime_count(Lower1, Upper, Add, Count).

perfect_numbers(Upper, Upper, AccNums, Nums) :-
    !,
    reverse(AccNums, Nums).

perfect_numbers(Lower, Upper, AccNums, Nums) :-
    Perfect is Lower - 1,
    chowla(Lower, Perfect),
    !,
    Lower1 is Lower + 1,
    AccNums1 = [Lower|AccNums],
    perfect_numbers(Lower1, Upper, AccNums1, Nums).

perfect_numbers(Lower, Upper, AccNums, Nums) :-
    Lower1 is Lower + 1,
    perfect_numbers(Lower1, Upper, AccNums, Nums).

main :-
    % Chowla numbers
    forall(between(1, 37, N), (
        chowla(N, C),
        format('chowla(~D) = ~D\n', [N, C])
    )),

    % Prime numbers
    Ranges = [100, 1000, 10000, 100000, 1000000, 10000000],
    forall(member(Range, Ranges), (
        prime_count(2, Range, 0, PrimeCount),
        format('There are ~D primes less than ~D.\n', [PrimeCount, Range])
    )),

    % Perfect numbers
    Limit = 35000000,
    perfect_numbers(2, Limit, [], Nums),
    forall(member(Perfect, Nums), (
        format('~D is a perfect number.\n', [Perfect])
    )),
    length(Nums, PerfectCount),
    format('There are ~D perfect numbers < ~D.\n', [PerfectCount, Limit]).
