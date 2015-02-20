-module( comma_quibbling ).

-export( [task/0] ).

task() -> [generate(X) || X <- [[], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"]]].



generate( List ) -> "{" ++ generate_content(List) ++ "}".

generate_content( [] ) -> "";
generate_content( [X] ) -> X;
generate_content( [X1, X2] ) -> string:join( [X1, "and", X2], " " );
generate_content( Xs ) ->
	[Last, Second_to_last | T] = lists:reverse( Xs ),
	With_commas = [X ++ "," || X <- T],
	string:join(lists:reverse([Last, "and", Second_to_last | With_commas]), " ").
