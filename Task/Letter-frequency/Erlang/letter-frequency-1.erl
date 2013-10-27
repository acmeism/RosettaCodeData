%% Implemented by Arjun Sunel
-module(letter_frequency).
-export([main/0, letter_freq/1]).
main() ->
	case  file:read_file("file.txt") of
		{ok, FileData} ->
			letter_freq(binary_to_list(FileData));
		_FileNotExist ->
			io:format("File do not exist~n")
	end.
	
letter_freq(Data) ->
	lists:foreach(fun(Char) ->
					LetterCount = lists:foldl(fun(Element, Count) ->
											case Element =:= Char of
												true ->
													Count+1;
												false ->
													Count
											end		
										end, 0, Data),
						
					case LetterCount >0 of
						true ->					
							io:format("~p	:	~p~n", [[Char], LetterCount]);
						false ->
							io:format("")
					end		
				end,  lists:seq(0, 222)).															
