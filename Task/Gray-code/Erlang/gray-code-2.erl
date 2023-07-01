-module(testgray).

test_encode(N) ->
  G = gray:encode(N),
  D = gray:decode(G),
  io:fwrite("~2B : ~5.2.0B : ~5.2.0B : ~5.2.0B : ~2B~n", [N, N, G, D, D]).

test_encode(N, N) -> [];
test_encode(I, N) when I < N -> test_encode(I), test_encode(I+1, N).

main(_) -> test_encode(0,32).
