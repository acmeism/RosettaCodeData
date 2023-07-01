#! /usr/bin/env escript

main([]) ->
    erlang:unregister(erl_signal_server),
    erlang:register(erl_signal_server, self()),
    Start = seconds(),
    os:set_signal(sigquit, handle),
    Pid = spawn(fun() -> output_loop(1) end),
    receive
        {notify, sigquit} ->
            erlang:exit(Pid, normal),
            Seconds = seconds() - Start,
            io:format("Program has run for ~b seconds~n", [Seconds])
    end.

seconds() ->
    calendar:datetime_to_gregorian_seconds({date(),time()}).

output_loop(N) ->
    io:format("~b~n",[N]),
    timer:sleep(500),
    output_loop(N + 1).
