-module(srv).
-export([start/0, wait/0]).

start() ->
   net_kernel:start([srv,shortnames]),
   erlang:set_cookie(node(), rosetta),
   Pid = spawn(srv,wait,[]),
   register(srv,Pid),
   io:fwrite("~p ready~n",[node(Pid)]),
   ok.

wait() ->
   receive
       {echo, Pid, Any} ->
           io:fwrite("-> ~p from ~p~n", [Any, node(Pid)]),
           Pid ! {hello, Any},
           wait();
       Any -> io:fwrite("Error ~p~n", [Any])
   end.
