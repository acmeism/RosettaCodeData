-module(hw).
-export([start/0]).

start() ->
   [ spawn(fun() ->  say(self(), X) end) || X <- ['Enjoy', 'Rosetta', 'Code'] ],
   wait(2),
   ok.

say(Pid,Str) ->
   io:fwrite("~s~n",[Str]),
   Pid ! done.

wait(N) ->
   receive
       done -> case N of
           0 -> 0;
           _N -> wait(N-1)
       end
   end.
