-module(church).
-export([main/1, zero/1]).
zero(_)    -> fun(F) -> F end.
succ(N)    -> fun(F) -> fun(X) -> F((N(F))(X)) end end.
add(N,M)   -> fun(F) -> fun(X) -> (M(F))((N(F))(X)) end end.
mult(N,M)  -> fun(F) -> fun(X) -> (M(N(F)))(X) end end.
power(B,E) -> E(B).

to_int(C) -> CountUp = fun(I) -> I + 1 end, (C(CountUp))(0).

from_int(0) -> fun church:zero/1;
from_int(I) -> succ(from_int(I-1)).

main(_) ->
    Zero  = fun church:zero/1,
    Three = succ(succ(succ(Zero))),
    Four  = from_int(4),
    lists:map(fun(C) -> io:fwrite("~w~n",[to_int(C)]) end,
	      [add(Three,Four),   mult(Three,Four),
	       power(Three,Four), power(Four,Three)]).
