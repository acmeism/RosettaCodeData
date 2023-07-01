-module(capture_demo).
-export([demo/0]).

demo() ->
    Funs = lists:map(fun (X) ->
                             fun () ->
                                     X * X
                             end
                     end,
                     lists:seq(1,10)),
    lists:foreach(fun (F) ->
                    io:fwrite("~B~n",[F()])
            end, Funs).
