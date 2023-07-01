-mode(compile).

% Integer math routines: factorial, power, square root, integer logarithm.
%
fac(N) -> fac(N, 1).
fac(N, A) when N < 2 -> A;
fac(N, A) -> fac(N - 1, N*A).


pow(_, N) when N < 0 -> pow_domain_error;
pow(2, N) -> 1 bsl N;
pow(A, N) -> ipow(A, N).

ipow(_, 0) -> 1;
ipow(A, 1) -> A;
ipow(A, 2) -> A*A;
ipow(A, N) ->
    case N band 1 of
        0 -> X = ipow(A, N bsr 1), X*X;
        1 -> A * ipow(A, N - 1)
    end.

% integer logarithm, based on Zeckendorf representations of integers.
%    https://www.keithschwarz.com/interesting/code/?dir=zeckendorf-logarithm
%    we need this, since the exponents get larger than IEEE-754 double can handle.

lognext({A, B, S, T}) -> {B, A+B, T, S*T}.
logprev({A, B, S, T}) -> {B-A, A, T div S, S}.

ilog(A, B) when (A =< 0) or (B < 2) -> ilog_domain_error;
ilog(A, B) ->
    UBound = bracket(A, {0, 1, 1, B}),
    backlog(A, UBound, 0).

bracket(A, State = {_, _, _, T}) when T > A -> State;
bracket(A, State) -> bracket(A, lognext(State)).

backlog(_, {0, _, 1, _}, Log) -> Log;
backlog(N, State = {A, _, S, _}, Log) when S =< N ->
    backlog(N div S, logprev(State), Log + A);
backlog(N, State, Log) -> backlog(N, logprev(State), Log).


isqrt(N) when N < 0 -> isqrt_domain_error;
isqrt(N) ->
    X0 = pow(2, ilog(N, 2) div 2),
    iterate(N, newton(X0, N), N).

iterate(A, B, _) when A =< B -> A;
iterate(_, B, N) -> iterate(B, newton(B, N), N).

newton(X, N) -> (X + N div X) div 2.


% With this out of the way, we can get down to some serious calculation.
%
term(N) -> {  % returns numerator and log10 of the denominator.
    (fac(6*N)*(N*(532*N + 126) + 9) bsl 5) div (3*pow(fac(N), 6)),
    6*N + 3
    }.

neg_term({N, D}) -> {-N, D}.
abs_term({N, D}) -> {abs(N), D}.

add_term(T1 = {_, D1}, T2 = {_, D2}) when D1 > D2 -> add_term(T2, T1);
add_term({N1, D1}, {N2, D2}) ->
    Scale = pow(10, D2 - D1),
    {N1*Scale + N2, D2}.

calculate(Prec) -> calculate(Prec, {0, 0}, 0).
calculate(Prec, T0, K) ->
    T1 = add_term(T0, term(K)),
    {N, D} = abs_term(add_term(neg_term(T1), T0)),
    Accuracy = D - ilog(N, 10),
    if
        Accuracy < Prec -> calculate(Prec, T1, K + 1);
        true -> T1
    end.

get_pi(Prec) ->
    {N0, D0} = calculate(Prec),
    % from the term, t = n0/10^d0, calculate 1/√t
    % if the denominator is an odd power of 10, add 1 to the denominator and multiply the numerator by 10.
    {N, D} = case D0 band 1 of
        0 -> {N0, D0};
        1 -> {10*N0, D0 + 1}
    end,
    [Three|Rest] = lists:sublist(
            integer_to_list(pow(10, D) div isqrt(N)), Prec),
    [Three, $. | Rest].

show_term({A, Decimals}) ->
    Str = integer_to_list(A),
    [$0, $.] ++ lists:duplicate(Decimals - length(Str), $0) ++ Str.

main(_) ->
    Terms = [term(N) || N <- lists:seq(0, 9)],
    io:format("The first 10 terms as scaled decimals are:~n"),
    [io:format("    ~s~n", [show_term(T)]) || T <- Terms],
    io:format("~nThe sum of these terms (pi^-2) is ~s~n",
                [show_term(lists:foldl(fun add_term/2, {0, 0}, Terms))]),
    Pi70 = get_pi(71),
    io:format("~npi to 70 decimal places:~n"),
    io:format("~s~n", [Pi70]).
