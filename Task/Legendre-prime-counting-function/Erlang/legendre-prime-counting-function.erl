-mode(native).

-define(LIMIT, 1000000000).

main(_) ->
    put(primes, array:from_list(primality:sieve(floor(math:sqrt(?LIMIT))))),
    ets:new(memphi, [set, named_table, protected]),
    output(0, 9).

nthprime(N) -> array:get(N - 1, get(primes)).

output(A, B) -> output(A, B, 1).
output(A, B, _) when A > B -> ok;
output(A, B, N) ->
    io:format("10^~b    ~b~n", [A, pi(N)]),
    output(A + 1, B, N * 10).

pi(N) ->
    Primes = get(primes),
    Last = array:get(array:size(Primes) - 1, Primes),
    if
        N =< Last -> small_pi(N);
        true ->
            A = pi(floor(math:sqrt(N))),
            phi(N, A) + A - 1
    end.

phi(X, 0) -> X;
phi(X, A) ->
    case ets:lookup(memphi, {X, A}) of
        [] ->
            Phi = phi(X, A-1) - phi(X div nthprime(A), A-1),
            ets:insert(memphi, {{X, A}, Phi}),
            Phi;

        [{{X, A}, Phi}] -> Phi
    end.

% Use binary search to count primes that we have already listed.
small_pi(N) ->
    Primes = get(primes),
    small_pi(N, Primes, 0, array:size(Primes)).

small_pi(_, _, L, H) when L >= (H - 1) -> L + 1;
small_pi(N, Primes, L, H) ->
    M = (L + H) div 2,
    P = array:get(M, Primes),
    if
        N > P -> small_pi(N, Primes, M, H);
        N < P -> small_pi(N, Primes, 0, M);
        true -> M + 1
    end.
