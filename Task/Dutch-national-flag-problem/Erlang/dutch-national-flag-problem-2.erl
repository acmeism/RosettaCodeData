main(_) ->
   L = random_balls(10),
   case is_dutch(L) of
     true  -> io:format("The random sequence ~p is already in the order of the Dutch flag!~n", [L]);
     false -> io:format("The starting random sequence is ~p;~nThe ordered sequence is ~p.~n", [L, dutch(L)])
   end.
