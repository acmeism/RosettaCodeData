-module( text_processing ).

-export( [file_contents/1, main/1] ).

-record( acc, {failed={"", 0, 0}, files=[], ok=0, total=0} ).

file_contents( Name ) ->
	{ok, Binary} = file:read_file( Name ),
	[line_contents(X) || X <- binary:split(Binary, <<"\r\n">>, [global]), X =/= <<>>].
	
main( Files ) ->
      Acc = lists:foldl( fun file/2, #acc{}, Files ),
      {Failed_date, Failed, _Continuation} = Acc#acc.failed,
      io:fwrite( "~nFile(s)=~p~nTotal=~.2f~nReadings=~p~nAverage=~.2f~n~nMaximum run(s) of ~p consecutive false readings ends at line starting with date(s): ~p~n",
        [lists:reverse(Acc#acc.files), Acc#acc.total, Acc#acc.ok, Acc#acc.total / Acc#acc.ok, Failed, Failed_date] ).



file( Name, #acc{files=Files}=Acc ) ->
	try
	Line_contents = file_contents( Name ),
	lists:foldl( fun file_content_line/2, Acc#acc{files=[Name | Files]}, Line_contents )

	catch
	_:Error ->
		io:fwrite( "Error: Failed to read ~s: ~p~n", [Name, Error] ),
		Acc
	end.

file_content_line( {Date, Value_flags}, #acc{failed=Failed, ok=Ok, total=Total}=Acc ) ->
	New_failed = file_content_line_failed( Value_flags, Date, Failed ),
	{Sum, Oks, Average} = file_content_line_oks_0( [X || {X, ok} <- Value_flags] ),
	io:fwrite( "Line=~p\tRejected=~p\tAccepted=~p\tLine total=~.2f\tLine average=~.2f~n", [Date, erlang:length(Value_flags) - Oks, Oks, Sum, Average] ),
	Acc#acc{failed=New_failed, ok=Ok + Oks, total=Total + Sum}.

file_content_line_failed( [], Date, {_Failed_date, Failed, Acc} ) when Acc > Failed ->
        {Date, Acc, Acc};
file_content_line_failed( [], _Date, Failed ) ->
        Failed;
file_content_line_failed( [{_V, error} | T], Date, {Failed_date, Failed, Acc} ) ->
        file_content_line_failed( T,  Date, {Failed_date, Failed, Acc + 1} );
file_content_line_failed( [_H | T],  Date, {_Failed_date, Failed, Acc} ) when Acc > Failed ->
        file_content_line_failed( T, Date, {Date, Acc, 0} );
file_content_line_failed( [_H | T], Date, {Failed_date, Failed, _Acc} ) ->
        file_content_line_failed( T, Date, {Failed_date, Failed, 0} ).

file_content_line_flag( N ) when N > 0 -> ok;
file_content_line_flag( _N ) -> error.

file_content_line_oks_0( [] ) -> {0.0, 0, 0.0};
file_content_line_oks_0( Ok_value_flags ) ->
        Sum = lists:sum( Ok_value_flags ),
        Oks = erlang:length( Ok_value_flags ),
        {Sum, Oks, Sum / Oks}.

file_content_line_value_flag( Binary, {[], Acc} ) ->
        Flag = file_content_line_flag( erlang:list_to_integer(binary:bin_to_list(Binary)) ),
        {[Flag], Acc};
file_content_line_value_flag( Binary, {[Flag], Acc} ) ->
        Value = erlang:list_to_float( binary:bin_to_list(Binary) ),
        {[], [{Value, Flag} | Acc]}.

line_contents( Line ) ->
	[Date_binary | Rest] = binary:split( Line, <<"\t">>, [global] ),
	{_Previous, Value_flags} = lists:foldr( fun file_content_line_value_flag/2, {[], []}, Rest ), % Preserve order
	{binary:bin_to_list( Date_binary ), Value_flags}.
