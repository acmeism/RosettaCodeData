main(_) ->
    AddPrimes = [N || N <- lists:seq(2,500), isprime(N) andalso isprime(digitsum(N))],
    io:format("The additive primes up to 500 are:~n~p~n~n", [AddPrimes]),
    io:format("There are ~b of them.~n", [length(AddPrimes)]).

isprime(N) when N < 2 -> false;
isprime(N) -> isprime(N, 2, 0, <<1, 2, 2, 4, 2, 4, 2, 4, 6, 2, 6>>).

isprime(N, D, J, Wheel) when J =:= byte_size(Wheel) -> isprime(N, D, 3, Wheel);
isprime(N, D, _, _) when D*D > N -> true;
isprime(N, D, _, _) when N rem D =:= 0 -> false;
isprime(N, D, J, Wheel) -> isprime(N, D + binary:at(Wheel, J), J + 1, Wheel).

digitsum(N) -> digitsum(N, 0).
digitsum(0, S) -> S;
digitsum(N, S) -> digitsum(N div 10, S + N rem 10).
