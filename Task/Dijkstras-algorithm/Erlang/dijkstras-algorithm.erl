-module(dijkstra).
-include_lib("eunit/include/eunit.hrl").
-export([dijkstrafy/3]).

% just hide away recursion so we have a nice interface
dijkstrafy(Graph, Start, End) when is_map(Graph) ->
	shortest_path(Graph, [{0, [Start]}], End, #{}).

shortest_path(_Graph, [], _End, _Visited) ->
	% if we're not going anywhere, it's time to start going back
	{0, []};
shortest_path(_Graph, [{Cost, [End | _] = Path} | _ ], End, _Visited) ->
	% this is the base case, and finally returns the distance and the path
	{Cost, lists:reverse(Path)};
shortest_path(Graph, [{Cost, [Node | _ ] = Path} | Routes], End, Visited) ->
	% this is the recursive case.
	% here we build a list of new "unvisited" routes, where the stucture is
	% a tuple of cost, then a list of paths taken to get to that cost from the "Start"
	NewRoutes = [{Cost + NewCost, [NewNode | Path]}
		|| {NewCost, NewNode} <- maps:get(Node, Graph),
			not maps:get(NewNode, Visited, false)],
	shortest_path(
		Graph,
		% add the routes we ripped off earlier onto the new routes
		% that we want to visit. sort the list of routes to get the
		% shortest routes (lowest cost) at the beginning.
		% Erlangs sort is already good enough, and it will sort the
		% tuples by the number at the beginning of each (the cost).
		lists:sort(NewRoutes ++ Routes),
		End,
		Visited#{Node => true}
	).

basic_test() ->
	Graph = #{
		a => [{7,b},{9,c},{14,f}],
		b => [{7,a},{10,c},{15,d}],
		c => [{10,b},{9,c},{11,d},{2,f}],
		d => [{15,b},{6,e},{11,c}],
		e => [{9,f},{6,d}],
		f => [{14,f},{2,c},{9,e}]
	},
	{Cost, Path}   = dijkstrafy(Graph, a, e),
	{20,[a,c,f,e]} = {Cost, Path},
	io:format(user, "The total cost was ~p and the path was: ", [Cost]),
	io:format(user, "~w~n", [Path]).
