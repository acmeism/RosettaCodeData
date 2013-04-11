-module(miller_rabin).

-compile([export_all]).

basis(N) when N>2 ->
    1 + random:uniform(N-2).

find_ds(D, S) ->
    case D rem 2 == 0 of
        true ->
            find_ds(trunc(D/2), S+1);
        false ->
            {D, S}
    end.

find_ds(N) ->
    find_ds(N-1, 0).

pow_mod(B, E, M) ->
    case E of
        0 -> 1;
        _ -> case trunc(E) rem 2 == 0 of
                 true  -> trunc(math:pow(pow_mod(B, trunc(E/2), M), 2)) rem M;
                 false -> trunc(B*pow_mod(B, E-1, M)) rem M
             end
    end.

mr_series(N, A, D, S) when N rem 2 == 1 ->
    Js = lists:seq(0, S),
    lists:map(fun(J) -> pow_mod(A, math:pow(2, J)*D, N) end, Js).

is_mr_prime(N, As) when N>2, N rem 2 == 1 ->
    {D, S} = find_ds(N),
    not lists:any(fun(A) ->
                          case mr_series(N, A, D, S) of
                              [1|_] -> false;
                              L     -> not lists:member(N-1, L)
                          end
                  end,
                  As).

proving_bases(N) when N < 1373653 ->
    [2, 3];
proving_bases(N) when N < 25326001 ->
    [2, 3, 5];
proving_bases(N) when N < 25000000000 ->
    [2, 3, 5, 7];
proving_bases(N) when N < 2152302898747->
    [2, 3, 5, 7, 11];
proving_bases(N) when N < 341550071728321 ->
    [2, 3, 5, 7, 11, 13];
proving_bases(N) when N < 341550071728321 ->
    [2, 3, 5, 7, 11, 13, 17].

random_bases(N, K) ->
    [basis(N) || _ <- lists:seq(1, K)].

is_prime(1) -> false;
is_prime(2) -> true;
is_prime(N) when N rem 2 == 0 -> false;
is_prime(N) when N < 341550071728321 ->
    is_mr_prime(N, proving_bases(N)).

is_probable_prime(N) ->
    is_mr_prime(N, random_bases(N, 20)).

first_1000() ->
    L = lists:seq(1,1000),
    lists:map(fun(X) ->
                      case is_prime(X) of
                          true ->
                              io:format("~w~n", [X]);
                          false ->
                              false
                      end
              end,
              L),
    ok.
