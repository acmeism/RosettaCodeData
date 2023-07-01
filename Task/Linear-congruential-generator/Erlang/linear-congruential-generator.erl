-module(lcg).
-export([bsd_seed/1, ms_seed/1, bsd_rand/0, ms_rand/0]).

bsd_seed(Seed) -> put(bsd_state, Seed).
ms_seed(Seed)  -> put(ms_state, Seed).

bsd_rand() ->
  State = (get(bsd_state) * 1103515245 + 12345) rem 2147483648,
  put(bsd_state,State),
  State.

ms_rand() ->
  State = (get(ms_state) * 214013 + 2531011) rem 2147483648,
  put(ms_state,State),
  State div 65536.

main(_) ->
  bsd_seed(0),
  ms_seed(0),
  io:fwrite("~10s~c~5s~n", ["BSD", 9, "MS"]),
  lists:map(fun(_) -> io:fwrite("~10w~c~5w~n", [bsd_rand(),9,ms_rand()]) end, lists:seq(1,10)).
