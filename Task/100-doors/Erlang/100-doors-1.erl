-module(hundoors).

-export([go/0]).

toggle(closed) -> open;
toggle(open) -> closed.

go() -> go([closed || _ <- lists:seq(1, 100)],[], 1, 1).
go([], L, N, _I) when N =:= 101 -> lists:reverse(L);
go([], L, N, _I) -> go(lists:reverse(L), [], N + 1, 1);
go([H|T], L, N, I) ->
  H2 = case I rem N of
    0 -> toggle(H);
    _ -> H
  end,
  go(T, [H2|L], N, I + 1).
