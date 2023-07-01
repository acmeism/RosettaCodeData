5> {Time,Result} = timer:tc(fun () -> lists:foreach(fun(X) -> X*X end, lists:seq(1,100000)) end).
{226391,ok}
6> Time/1000000. % Time is in microseconds.
0.226391
7> % Time is in microseconds.
