-module(tonelli_shanks).
-export([tonelli/2, legendre/2, task/1,  main/1]).

%% Public API
tonelli(N, P) ->
    case legendre(N, P) of
        1 ->
            {Q, S} = decompose(P - 1, 0),
            if
                S =:= 1 ->
                    mod_pow(N, (P + 1) div 4, P);
                S > 1 ->
                    Z = find_non_square(P),
                    C = mod_pow(Z, Q, P),
                    R = mod_pow(N, (Q + 1) div 2, P),
                    T = mod_pow(N, Q, P),
                    tonelli_loop(P, C, R, T, S)
            end;
        _ ->
            error({not_a_square_mod_p, N, P})
    end.

%% Tonelli-Shanks loop
tonelli_loop(P, _C, R, T, _M) when T =:= 1 ->
    R;
tonelli_loop(P, C, R, T, M) ->
    {T2, I} = find_least_i(T, 1, M, P),
    B = mod_pow(C, mod_pow(2, M - I - 1, P - 1), P),
    C1 = mod_mul(B, B, P),
    R1 = mod_mul(R, B, P),
    T1 = mod_mul(T, C1, P),
    tonelli_loop(P, C1, R1, T1, I).

%% Find smallest i such that t^(2^i) ≡ 1 mod p
find_least_i(T, I, M, P) when I < M ->
    T2 = mod_mul(T, T, P),
    if
        T2 =:= 1 -> {T2, I};
        true -> find_least_i(T2, I + 1, M, P)
    end;
find_least_i(_, _, _, _) ->
    error(no_i_found).

%% Legendre symbol: a^((p-1)/2) mod p
legendre(A, P) ->
    mod_pow(A, (P - 1) div 2, P).

%% Decompose p-1 = q * 2^s where q is odd
decompose(Q, S) when Q rem 2 =:= 0 ->
    decompose(Q div 2, S + 1);
decompose(Q, S) ->
    {Q, S}.

%% Find a quadratic non-residue (Legendre = p - 1)
find_non_square(P) ->
    find_non_square(2, P).

find_non_square(Z, P) ->
    case legendre(Z, P) of
        L when L =:= P - 1 -> Z;
        _ -> find_non_square(Z + 1, P)
    end.

%% Modular exponentiation: base^exp mod mod
mod_pow(Base, Exp, Mod) ->
    mod_pow(Base, Exp, Mod, 1).

mod_pow(_Base, 0, _Mod, Acc) ->
    Acc;
mod_pow(Base, Exp, Mod, Acc) ->
    Acc1 = case Exp rem 2 of
               1 -> (Acc * Base) rem Mod;
               0 -> Acc
           end,
    Base2 = (Base * Base) rem Mod,
    mod_pow(Base2, Exp div 2, Mod, Acc1).

%% Modular multiplication
mod_mul(A, B, Mod) ->
    (A * B) rem Mod.

%% Test cases
task(TestCases) ->
    lists:foreach(fun([N, P]) ->
        try
            R = tonelli(N, P),
            io:format("n = ~p p = ~p~n  roots : ~p ~p~n", [N, P, R, P - R])
        catch
            _:Error ->
                io:format("Error for n=~p, p=~p: ~p~n", [N, P, Error])
        end
    end, TestCases).

main(_) ->
    Cases = [
        [10, 13],
        [56, 101],
        [1030, 10009],
        [44402, 100049],
        [665820697, 1000000009],
        [881398088036, 1000000000039],
        [41660815127637347468140745042827704103445750172002, 100000000000000000000000000000000000000000000000577]
    ],
    task(Cases),

    % Test error case
    try
        tonelli(1032, 1009),
        io:format("Error: Should have failed~n")
    catch
        _:Error ->
            io:format("Correctly caught error: ~p~n", [Error])
    end.
