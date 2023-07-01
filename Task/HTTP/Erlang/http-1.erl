-module(main).
-export([main/1]).

main([Url|[]]) ->
   inets:start(),
   case http:request(Url) of
       {ok, {_V, _H, Body}} -> io:fwrite("~p~n",[Body]);
       {error, Res} -> io:fwrite("~p~n", [Res])
   end.
