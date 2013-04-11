-module(cc).
-export([start/0, reader/2]).

start() ->
   Pid = spawn(cc,reader,[self(), 0]),
   case file:open("input.txt", read) of
       {error, Any} -> io:fwrite("Error ~p~n",[Any]);
       {ok, Io} ->
           process(Io, Pid),
           file:close(Io)
   end,
   ok.

process(Io, Pid) ->
   case io:get_line(Io,"") of
       eof ->
           Pid ! count,
           wait();
       Any ->
           Pid ! Any,
           process(Io, Pid)
   end.

wait() ->
   receive
       I -> io:fwrite("Count:~p~n", [I])
   end.

reader(Pid, C) ->
   receive
       count -> Pid ! C;
       Any ->
           io:fwrite("~s", [Any]),
           reader(Pid, C+1)
   end.
