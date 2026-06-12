-module(task_10001th_prime).

-export([main/0]).

% 2 and 3 are both primes, so we start searching at 5
main() -> search(5, 2, 2).

search(N, Inc, Count) when Count < 10_001 ->
    case is_prime(N) of
        true -> search(N + Inc, 6 - Inc, Count + 1);
        false -> search(N + Inc, 6 - Inc, Count)
    end;
search(N, Inc, _) -> N - 6 + Inc.

is_prime(P) -> is_prime(P, 5, 2).

is_prime(N, P, _) when P * P > N -> true;
is_prime(N, P, _) when N rem P =:= 0 -> false;
is_prime(N, P, Inc) -> is_prime(N, P + Inc, 6 - Inc).
