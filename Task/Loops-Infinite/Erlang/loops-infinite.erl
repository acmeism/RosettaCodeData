-module (main).
-export ([main/1]).

main(Any) ->
  io:fwrite("SPAM~n",[]),
  main(Any)
