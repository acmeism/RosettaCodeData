1> Ls = fun(Dir) ->
1> {ok, DirContents} = file:list_dir(Dir),
1> [io:format("~s~n", [X]) || X <- lists:sort(DirContents)]
1> end.
#Fun<erl_eval.6.36634728>
2> Ls("foo").
bar
[ok]
3> Ls("foo/bar").
1
2
a
b
[ok,ok,ok,ok]
