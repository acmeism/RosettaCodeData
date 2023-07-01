#! /usr/bin/escript

-mode(native).
-import(lists, [map/2, reverse/1]).

binary_to_ratio(B) ->
    {match, [_, Num, Den]} = re:run(B, "([0-9]+)/([0-9]+)"),
    {binary_to_integer(binary:part(B, Num)),
     binary_to_integer(binary:part(B, Den))}.

load(Program) ->
    map(fun binary_to_ratio/1, re:split(Program, "[ ]+")).

step(_, []) -> halt;
step(N, [F|Fs]) ->
    {P, Q} = mulrat(F, {N, 1}),
    case Q of
        1 -> P;
        _ -> step(N, Fs)
    end.

exec(K, N, Program) -> reverse(exec(K - 1, N, fun (_) -> true end, Program, [N])).
exec(K, N, Pred, Program) -> reverse(exec(K - 1, N, Pred, Program, [N])).

exec(0, _, _, _, Steps) -> Steps;
exec(K, N, Pred, Program, Steps) ->
    case step(N, Program) of
        halt -> Steps;
        M -> case Pred(M) of
                true  -> exec(K - 1, M, Pred, Program, [M|Steps]);
                false -> exec(K, M, Pred, Program, Steps)
            end
    end.


is_pow2(N) -> N band (N - 1) =:= 0.

lowbit(N) -> lowbit(N, 0).
lowbit(N, K) ->
    case N band 1 of
        0 -> lowbit(N bsr 1, K + 1);
        1 -> K
    end.

main(_) ->
    PrimeGen = load("17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1"),
    io:format("The first few states of the Fractran prime automaton are: ~p~n~n", [exec(20, 2, PrimeGen)]),
    io:format("The first few primes are: ~p~n", [tl(map(fun lowbit/1, exec(26, 2, fun is_pow2/1, PrimeGen)))]).


% rational multiplication

mulrat({A, B}, {C, D}) ->
    {P, Q} = {A*C, B*D},
    G = gcd(P, Q),
    {P div G, Q div G}.

gcd(A, 0) -> A;
gcd(A, B) -> gcd(B, A rem B).
