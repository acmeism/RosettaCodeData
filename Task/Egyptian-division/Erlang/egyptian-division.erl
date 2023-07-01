-module(egypt).

-export([ediv/2]).

ediv(A, B) ->
    {Twos, Ds} = genpowers(A, [1], [B]),
    {Quot, C} = accumulate(A, Twos, Ds),
    {Quot, abs(C - A)}.

genpowers(A, [_|Ts], [D|Ds]) when D > A -> {Ts, Ds};
genpowers(A, [T|_] = Twos, [D|_] = Ds) -> genpowers(A, [2*T|Twos], [D*2|Ds]).

accumulate(N, Twos, Ds) -> accumulate(N, Twos, Ds, 0, 0).
accumulate(_, [], [], Q, C) -> {Q, C};
accumulate(N, [T|Ts], [D|Ds], Q, C) when (C + D) =< N -> accumulate(N, Ts, Ds, Q+T, C+D);
accumulate(N, [_|Ts], [_|Ds], Q, C) -> accumulate(N, Ts, Ds, Q, C).
