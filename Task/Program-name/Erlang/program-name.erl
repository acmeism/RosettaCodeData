-module(scriptname).

main(_) ->
	Program = ?FILE,
	io:format("Program: ~s~n", [Program]).
