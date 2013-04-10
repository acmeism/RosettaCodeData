-module(events).
-compile(export_all).

log(Msg) ->
    {H,M,S} = erlang:time(),
    io:fwrite("~2.B:~2.B:~2.B => ~s~n",[H,M,S,Msg]).

task() ->
    log("Task start"),
    receive
        go -> ok
    end,
    log("Task resumed").

main() ->
    log("Program start"),
    P = spawn(?MODULE,task,[]),
    log("Program sleeping"),
    timer:sleep(1000),
    log("Program signalling event"),
    P ! go,
    timer:sleep(100).
