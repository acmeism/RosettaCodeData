lists:foreach(fun({A,B,C}) ->
io:format("~s~n",[[A,B,C]]) end,
              lists:zip3("abc", "ABC", "123")).
