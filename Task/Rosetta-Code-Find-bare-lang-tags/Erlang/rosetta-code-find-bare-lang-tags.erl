-module( find_bare_lang_tags ).

-export( [task/0] ).

task() ->
	{ok, Binary} = file:read_file( "priv/find_bare_lang_tags_1" ),
	Lines = string:tokens( erlang:binary_to_list(Binary), "\n" ),
	{_Lang, Dict} = lists:foldl( fun count_empty_lang/2, {"no language", dict:new()}, Lines ),
	Count_langs = [{dict:fetch(X, Dict), X} || X <- dict:fetch_keys(Dict)],
	io:fwrite( "~p bare language tags.~n", [lists:sum([X || {X, _Y} <- Count_langs])] ),
	[io:fwrite( "~p in ~p~n", [X, Y] ) || {X, Y} <- Count_langs].



count_empty_lang( Line, {Lang, Dict} ) ->
	Empty_lang = string:str( Line, "<lang>" ),
	New_dict = dict_update_counter( Empty_lang, Lang, Dict ),
	New_lang = new_lang( string:str( Line,"=={{header|" ), Line, Lang ),
	{New_lang, New_dict}.

dict_update_counter( 0, _Lang, Dict ) -> Dict;
dict_update_counter( _Start, Lang, Dict ) -> dict:update_counter( Lang, 1, Dict ).

new_lang( 0, _Line, Lang ) -> Lang;
new_lang( _Start, Line, _Lang ) ->
	Start = string:str( Line, "|" ),
	Stop = string:rstr( Line, "}}==" ),
	string:sub_string( Line, Start+1, Stop-1 ).
