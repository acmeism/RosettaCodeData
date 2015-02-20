-module( csv_data ).

-export( [change/2, from_binary/1, from_file/1, into_file/2, task/0] ).

change( CSV, Changes ) -> lists:foldl( fun change_foldl/2, CSV, Changes ).

from_binary( Binary ) ->
        Lines = binary:split( Binary, <<"\n">>, [global] ),
        [binary:split(X, <<",">>, [global]) || X <- Lines].

from_file( Name ) ->
        {ok, Binary} = file:read_file( Name ),
        from_binary( Binary ).

into_file( Name, CSV ) ->
        Binaries = join_binaries( [join_binaries(X, <<",">>) || X <- CSV], <<"\n">> ),
        file:write_file( Name, Binaries ).

task() ->
       CSV = from_file( "CSV_file.in" ),
       New_CSV = change( CSV, [{2,3,<<"23">>}, {4,4,<<"44">>}] ),
       into_file( "CSV_file.out", New_CSV ).



change_foldl( {Row_number, Column_number, New}, Acc ) ->
        {Row_befores, [Row_columns | Row_afters]} = split( Row_number, Acc ),
        {Column_befores, [_Old | Column_afters]} = split( Column_number, Row_columns ),
        Row_befores ++ [Column_befores ++ [New | Column_afters]] ++ Row_afters.

join_binaries( Binaries, Binary ) ->
        [_Last | Rest] = lists:reverse( lists:flatten([[X, Binary] || X <- Binaries]) ),
        lists:reverse( Rest ).

split( 1, List ) -> {[], List};
split( N, List ) -> lists:split( N - 1, List ).
