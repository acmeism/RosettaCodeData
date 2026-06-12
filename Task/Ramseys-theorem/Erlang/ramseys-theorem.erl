-module(ramsey_theorem).
-export([main/0]).

main() ->
	Vertices = lists:seq(0,16),
	G = create_graph(Vertices),
	String_ramsey =
		case ramsey_check(G,Vertices) of
			true ->
				"Satisfies Ramsey condition.";
			{false,Reason} ->
				"Not satisfies Ramsey condition:\n"
				++ io_lib:format("~p\n",[Reason])
		end,
	io:format("~s\n~s\n",[print_graph(G,Vertices),String_ramsey]).

create_graph(Vertices) ->
	G = digraph:new([cyclic]),
	[digraph:add_vertex(G,V) || V <- Vertices],
	[begin
		J = ((I + K) rem 17),
		digraph:add_edge(G, I, J),
		digraph:add_edge(G, J, I)
	 end || I <- Vertices, K <- [1,2,4,8]],
	G.

print_graph(G,Vertices) ->
	Edges =
		[{V1,V2} ||
			V1 <- digraph:vertices(G),
			V2 <- digraph:out_neighbours(G, V1)],
	lists:flatten(
		[[
			[case I of
			 	J ->
			 		$-;
			 	_ ->
			 		case lists:member({I,J},Edges) of
			 			true -> $1;
			 			false -> $0
			 		end
			 end,$ ]
		 || I <- Vertices] ++ [$\n] || J <- Vertices]).

ramsey_check(G,Vertices) ->
	Edges =
		[{V1,V2} ||
			V1 <- digraph:vertices(G),
			V2 <- digraph:out_neighbours(G, V1)],
	ListConditions =
		[begin
			All_cases =
				[lists:member({V1,V2},Edges),
				 lists:member({V1,V3},Edges),
				 lists:member({V1,V4},Edges),
				 lists:member({V2,V3},Edges),
				 lists:member({V2,V4},Edges),
				 lists:member({V3,V4},Edges)],
			{V1,V2,V3,V4,
			 lists:any(fun(X) -> X end, All_cases),
			 not(lists:all(fun(X) -> X end, All_cases))}
		end
		 || V1 <- Vertices, V2 <- Vertices, V3 <- Vertices, V4 <- Vertices,
		 	V1/=V2,V1/=V3,V1/=V4,V2/=V3,V2/=V4,V3/=V4],
	case lists:all(fun({_,_,_,_,C1,C2}) -> C1 and C2 end,ListConditions) of
		true -> true;
		false ->
			{false,
				[{wholly_unconnected,V1,V2,V3,V4}
				 || {V1,V2,V3,V4,false,_} <- ListConditions]
				++ [{wholly_connected,V1,V2,V3,V4}
				 || {V1,V2,V3,V4,_,false} <- ListConditions]}
	end.
