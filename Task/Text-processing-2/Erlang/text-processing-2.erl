-module( text_processing2 ).

-export( [task/0] ).

task() ->
	Name = "priv/readings.txt",
	try
	File_contents = text_processing:file_contents( Name ),
	[correct_field_format(X) || X<- File_contents],
	{_Previous, Duplicates} = lists:foldl( fun date_duplicates/2, {"", []}, File_contents ),
	io:fwrite( "Duplicates: ~p~n", [Duplicates] ),
	Good = [X || X <- File_contents, is_all_good_readings(X)],
	io:fwrite( "Good readings: ~p~n", [erlang:length(Good)] )

	catch
	_:Error ->
		io:fwrite( "Error: Failed when checking ~s: ~p~n", [Name, Error] )
	end.



correct_field_format( {_Date, Value_flags} ) ->
	Corret_number = value_flag_records(),
	{correct_field_format, Corret_number} = {correct_field_format, erlang:length(Value_flags)}.

date_duplicates( {Date, _Value_flags}, {Date, Acc} ) -> {Date, [Date | Acc]};
date_duplicates( {Date, _Value_flags}, {_Other, Acc} ) -> {Date, Acc}.

is_all_good_readings( {_Date, Value_flags} ) -> value_flag_records() =:= erlang:length( [ok || {_Value, ok} <-  Value_flags] ).

value_flag_records() -> 24.
