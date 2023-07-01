doors() ->
     F = fun(X) -> Root = math:pow(X,0.5), Root == trunc(Root) end,
     Out = fun(X, true) -> io:format("Door ~p: open~n",[X]);
              (X, false)-> io:format("Door ~p: close~n",[X]) end,
     [Out(X,F(X)) || X <- lists:seq(1,100)].
