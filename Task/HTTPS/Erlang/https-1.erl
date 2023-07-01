-module(main).
-export([main/1]).

main([Url|[]]) ->
   inets:start(),
   ssl:start(),
   case http:request(get, {URL, []}, [{ssl,[{verify,0}]}], []) of
       {ok, {_V, _H, Body}} -> io:fwrite("~p~n",[Body]);
       {error, Res} -> io:fwrite("~p~n", [Res])
   end.
