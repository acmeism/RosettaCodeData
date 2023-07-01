main() ->
    io:format("Sleeping...~n"),
    receive
    after 1000 -> ok %% in milliseconds
    end,
    io:format("Awake!~n").
