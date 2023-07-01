letter_freq( Data ) ->
	Dict = lists:foldl( fun (Char, Dict) -> dict:update_counter( Char, 1, Dict ) end, dict:new(), Data ),
	[io:fwrite( "~p	:	~p~n", [[X], dict:fetch(X, Dict)]) || X <- dict:fetch_keys(Dict)].
