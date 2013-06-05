%% Implemented by Arjun Sunel
-module(forever).
-export([main/0, for/0]).

main() ->
	for().
  	
for() ->
	K = random:uniform(19),
	if  K==10 ->
		io:format("~p~n",[K]);
	true ->
		M = random:uniform(19),
		io:format("~p~n",[M]),
   		for()
	end.		
