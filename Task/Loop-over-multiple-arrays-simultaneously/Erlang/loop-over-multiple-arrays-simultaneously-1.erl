lists:zipwith3(fun(A,B,C)->
io:format("~s~n",[[A,B,C]]) end, "abc", "ABC", "123").
