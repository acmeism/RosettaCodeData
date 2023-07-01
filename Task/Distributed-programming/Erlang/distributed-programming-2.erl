-module(client).
-export([start/0, wait/0]).

start() ->
   net_kernel:start([client,shortnames]),
   erlang:set_cookie(node(), rosetta),
   {ok,[[Srv]]} = init:get_argument(server),
   io:fwrite("connecting to ~p~n", [Srv]),
   {srv, list_to_atom(Srv)} ! {echo,self(), hi},
   wait(),
   ok.

wait() ->
   receive
       {hello, Any} -> io:fwrite("Received ~p~n", [Any]);
       Any -> io:fwrite("Error ~p~n", [Any])
   end.
