main(_) ->
    test(),
    io:format("The largest prime factor of 600,851,475,143 is ~w~n", [gpf(600851475143)]).

gpf(N) -> gpf(N, 2, 0, <<1, 2, 2, 4, 2, 4, 2, 4, 6, 2, 6>>).
gpf(N, D, J, Wheel) when J =:= byte_size(Wheel) -> gpf(N, D, 3, Wheel);
gpf(N, D, _, _) when D*D > N -> N;
gpf(N, D, J, Wheel) when N rem D =:= 0 -> gpf(N div D, D, J, Wheel);
gpf(N, D, J, Wheel) -> gpf(N, D + binary:at(Wheel, J), J + 1, Wheel).

test() ->
    3 = gpf(27),
    5 = gpf(125),
    7 = gpf(98),
    101 = gpf(101),
    23 = gpf(23 * 13).
