%% Implemented by Arjun Sunel
-module(loop_step).
-export([main/0, for_loop/1]).

 % This Erlang code for "For Loop" is equivalent to: " for (i=start;  i<end ; i=i+2){ printf("* ");} " in C language.

main() ->
	for_loop(1).

 for_loop(N)  when N < 4 ->
	io:fwrite("* "),
	for_loop(N+2);
	
for_loop(N) when N >= 4->
	io:format("").
