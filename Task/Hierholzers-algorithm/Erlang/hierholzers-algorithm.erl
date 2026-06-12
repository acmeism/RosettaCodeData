-module(hierholzers_algorithm).
-export([main/1, print_circuit/1]).

main(_) ->
    % First adjacency list example
    AdjacencyList1 = [
        [1],     % Vertex 0 connects to vertex 1
        [2],     % Vertex 1 connects to vertex 2
        [0]      % Vertex 2 connects to vertex 0
    ],
    print_circuit(AdjacencyList1),

    % Second adjacency list example
    AdjacencyList2 = [
        [1, 6],  % Vertex 0 connects to vertices 1, 6
        [2],     % Vertex 1 connects to vertex 2
        [0, 3],  % Vertex 2 connects to vertices 0, 3
        [4],     % Vertex 3 connects to vertex 4
        [2, 5],  % Vertex 4 connects to vertices 2, 5
        [0],     % Vertex 5 connects to vertex 0
        [4]      % Vertex 6 connects to vertex 4
    ],
    print_circuit(AdjacencyList2).

print_circuit([]) ->
    ok;
print_circuit(AdjacencyList) ->
    Path = [0],  % Start with vertex 0 on the path stack
    Circuit = [],
    CurrentVertex = 0,

    % Convert adjacency list to mutable array-like structure using dict
    AdjDict = create_adjacency_dict(AdjacencyList, 0, dict:new()),

    FinalCircuit = find_circuit(CurrentVertex, Path, Circuit, AdjDict),
    print_result(lists:reverse(FinalCircuit)).

% Helper function to create a dictionary from adjacency list
create_adjacency_dict([], _, Dict) ->
    Dict;
create_adjacency_dict([Neighbors | Rest], Index, Dict) ->
    create_adjacency_dict(Rest, Index + 1, dict:store(Index, Neighbors, Dict)).

% Main algorithm implementation
find_circuit(CurrentVertex, [], Circuit, _) ->
    Circuit;
find_circuit(CurrentVertex, Path, Circuit, AdjDict) ->
    case dict:find(CurrentVertex, AdjDict) of
        {ok, []} ->
            % No more neighbors - backtrack
            NewCircuit = [CurrentVertex | Circuit],
            case Path of
                [] -> NewCircuit;
                [NewCurrentVertex | RestPath] ->
                    find_circuit(NewCurrentVertex, RestPath, NewCircuit, AdjDict)
            end;
        {ok, Neighbors} ->
            % Has neighbors - move forward
            NextVertex = lists:last(Neighbors),
            RemainingNeighbors = lists:droplast(Neighbors),
            NewAdjDict = dict:store(CurrentVertex, RemainingNeighbors, AdjDict),
            NewPath = [CurrentVertex | Path],
            find_circuit(NextVertex, NewPath, Circuit, NewAdjDict);
        error ->
            % Vertex not found - backtrack
            NewCircuit = [CurrentVertex | Circuit],
            case Path of
                [] -> NewCircuit;
                [NewCurrentVertex | RestPath] ->
                    find_circuit(NewCurrentVertex, RestPath, NewCircuit, AdjDict)
            end
    end.

% Print the circuit with arrows
print_result([]) ->
    io:format("~n");
print_result([Vertex]) ->
    io:format("~w~n", [Vertex]);
print_result([Vertex | Rest]) ->
    io:format("~w => ", [Vertex]),
    print_result(Rest).
