-module(egypt).

-import(lists, [reverse/1, seq/2]).
-export([frac/2, show/2, rosetta/0]).

rosetta() ->
    Fractions = [{N, D, second(frac(N, D))} || N <- seq(2,99), D <- seq(N+1, 99)],
    {Longest, A1, B1} = findmax(fun length/1, Fractions),
    io:format("~b/~b has ~b terms.~n", [A1, B1, Longest]),
    {Largest, A2, B2} = findmax(fun (L) -> hd(reverse(L)) end, Fractions),
    io:format("~b/~b has a really long denominator. (~b)~n", [A2, B2, Largest]).

second({_, B}) -> B.

findmax(Fn, L) -> findmax(Fn, L, 0, 0, 0).
findmax(_, [], M, A, B) -> {M, A, B};
findmax(Fn, [{A,B,Frac}|Fracs], M, A0, B0) ->
    Val = Fn(Frac),
    case Val > M of
        true  -> findmax(Fn, Fracs, Val, A, B);
        false -> findmax(Fn, Fracs, M, A0, B0)
    end.

show(A, B) ->
    {W, R} = frac(A, B),
    case W of
        0 -> ok;
        _ -> io:format("[~b] ", [W])
    end,
    case R of
        [] -> ok;
        [D0|Ds] ->
            io:format("1/~b ", [D0]),
            [io:format("+ 1/~b ", [D]) || D <- Ds],
            ok
    end.

frac(A, B) ->
    {A div B, reverse(proper(A rem B, B, []))}.

proper(0, _, L) -> L;
proper(1, Y, L) -> [Y|L];
proper(X, Y, L) ->
    D = ceildiv(Y, X),
    X2 = mod(-Y, X),
    Y2 = Y*ceildiv(Y, X),
    proper(X2, Y2, [D|L]).

ceildiv(A, B) ->
    Q = A div B,
    case A rem B of
        0 -> Q;
        _ -> Q+1
    end.

mod(A, M) ->
    B = A rem M,
    if
        B < 0 -> B + M;
        true -> B
    end.
