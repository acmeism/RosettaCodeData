-module(solution1).
-export([main/0]).
babbage(N,E) when N*N rem 1000000 == 269696 ->
	io:fwrite("~p",[N]);
babbage(N,E) ->
	case E of
	4 -> babbage(N+2,6);
	6 -> babbage(N+8,4)
end.
main()->
	babbage(4,4).
