9> timer:tc(fun (X) -> lists:foreach(fun(Y) -> Y*Y end, lists:seq(1,X)) end, [1000000]).
{2293844,ok}
