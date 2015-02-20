-module(crt).
-import(lists, [zip/2, unzip/1, foldl/3, sum/1]).
-export([egcd/2, mod/2, mod_inv/2, chinese_remainder/1]).

egcd(_, 0) -> {1, 0};
egcd(A, B) ->
    {S, T} = egcd(B, A rem B),
    {T, S - (A div B)*T}.

mod_inv(A, B) ->
    {X, Y} = egcd(A, B),
    if
        A*X + B*Y =:= 1 -> X;
        true -> undefined
    end.

mod(A, M) ->
    X = A rem M,
    if
        X < 0 -> X + M;
        true -> X
    end.

calc_inverses([], []) -> [];
calc_inverses([N | Ns], [M | Ms]) ->
    case mod_inv(N, M) of
        undefined -> undefined;
        Inv -> [Inv | calc_inverses(Ns, Ms)]
    end.

chinese_remainder(Congruences) ->
    {Residues, Modulii} = unzip(Congruences),
    ModPI = foldl(fun(A, B) -> A*B end, 1, Modulii),
    CRT_Modulii = [ModPI div M || M <- Modulii],
    case calc_inverses(CRT_Modulii, Modulii) of
        undefined -> undefined;
        Inverses ->
            Solution = sum([A*B || {A,B} <- zip(CRT_Modulii,
                                    [A*B || {A,B} <- zip(Residues, Inverses)])]),
            mod(Solution, ModPI)
    end.
