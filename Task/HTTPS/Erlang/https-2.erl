-module(main).
-export([main/1]).

main([Url|[]]) ->
   inets:start(),
   ssl:start(),
   http:request(get, {Url, [] }, [{ssl,[{verify,0}]}], [{sync, false}]),
   receive
       {http, {_ReqId, Res}} -> io:fwrite("~p~n",[Res]);
       _Any -> io:fwrite("Error: ~p~n",[_Any])
       after 10000 -> io:fwrite("Timed out.~n",[])
   end.
