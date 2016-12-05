-module(maze).
-record(maze, {g, m, n}).
-export([generate_default/0, generate_MxN/2]).

make_maze(M, N) ->
    Maze = #maze{g = digraph:new(), m = M, n = N},
    lists:foreach(fun(X) -> digraph:add_vertex(Maze#maze.g, X) end, lists:seq(0, M * N - 1)),
    Maze.

row_at(V, Maze) -> trunc(V / Maze#maze.n).
col_at(V, Maze) -> V - row_at(V, Maze) * Maze#maze.n.
vertex_at(Row, Col, Maze) -> Cell_Exists = cell_exists(Row, Col, Maze), if Cell_Exists -> Row * Maze#maze.n + Col; true -> -1 end.
cell_exists(Row, Col, Maze) -> (Row >= 0) and (Row < Maze#maze.m) and (Col >= 0) and (Col < Maze#maze.n).

adjacent_cells(V, Maze) -> % ordered: left, up, right, down
    adjacent_cell(cell_left, V, Maze)++adjacent_cell(cell_up, V, Maze)++adjacent_cell(cell_right, V, Maze)++adjacent_cell(cell_down, V, Maze).

adjacent_cell(cell_left, V, Maze) -> case (col_at(V, Maze) == 0) of true -> []; _Else -> [V - 1] end;
adjacent_cell(cell_up, V, Maze) -> case (row_at(V, Maze) == 0) of true -> []; _Else -> [V - Maze#maze.n] end;
adjacent_cell(cell_right, V, Maze) -> case (col_at(V, Maze) == Maze#maze.n - 1) of true -> []; _Else -> [V + 1] end;
adjacent_cell(cell_down, V, Maze) -> case (row_at(V, Maze) == Maze#maze.m - 1) of true -> []; _Else -> [V + Maze#maze.n] end.

connect_all(V, Maze) ->
    lists:foreach(fun(X) -> digraph:add_edge(Maze#maze.g, V, X) end, adjacent_cells(V, Maze)).

make_maze(M, N, all_connected) ->
    Maze = make_maze(M, N),
    lists:foreach(fun(X) -> connect_all(X, Maze) end, lists:seq(0, M * N - 1)),
    Maze.

maze_parts(Maze) ->
    SPR = Maze#maze.n + 1,      % slots per row is #columns + 1
    NPR = (Maze#maze.m * 2) + 1,    % # part rows is #(rows * 2) + 1
    [make_part(Maze, trunc(Index/SPR), Index - trunc(Index/SPR) * SPR) || Index <- lists:seq(0, (SPR * NPR) - 1)].

draw_part(Part) ->
    case Part of
        {pwall, pclosed} -> io:format("+---");
        {pwall, popen} -> io:format("+   ");
        {pwall, pend} -> io:format("+~n");
        {phall, pclosed} -> io:format("|   ");
        {phall, popen} -> io:format("    ");
        {phall, pend} -> io:format("|~n")
    end.

has_neighbour(Maze, Row, Col, Direction) ->
    V = vertex_at(Row, Col, Maze),
    if
        V >= 0 ->
            Adjacent = adjacent_cell(Direction, V, Maze),
            if
                length(Adjacent) > 0 ->
                    Neighbours = digraph:out_neighbours(Maze#maze.g, lists:nth(1, Adjacent)),
                    lists:member(V, Neighbours);
                true -> false
            end;
        true -> false
    end.

make_part(Maze, DoubledRow, Col) ->
    if
        trunc(DoubledRow/2) * 2 == DoubledRow -> % --- (even row) making a wall above the cell
            make_part(Maze, trunc(DoubledRow/2), Col, cell_up, pwall);
        true -> % ---otherwise (odd row) making a hall through the cell
            make_part(Maze, trunc(DoubledRow/2), Col, cell_left, phall)
    end.

make_part(Maze, _, Col, _, Part_Type) when Col == Maze#maze.n -> {Part_Type, pend};
make_part(Maze, Row, Col, Direction, Part_Type) ->
    Has_Neighbour = has_neighbour(Maze, Row, Col, Direction),
    if
        Has_Neighbour -> {Part_Type, popen};
        true -> {Part_Type, pclosed}
    end.

shuffle([], Acc) -> Acc;
shuffle(List, Acc) ->
    Elem = lists:nth(random:uniform(length(List)), List),
    shuffle(lists:delete(Elem, List), Acc++[Elem]).

processDepthFirst(Maze) ->
    if
        Maze#maze.m * Maze#maze.n == 0 -> [{pwall, pend}];
        true ->
            Visited = array:new([{size, Maze#maze.m * Maze#maze.n},{fixed,true},{default,false}]),
            {_, Path} = processDepthFirst(Maze, -1, random:uniform(Maze#maze.m * Maze#maze.n) - 1, {Visited, []}),
            Path
    end.

processDepthFirst(Maze, Vfrom, V, VandP) ->
    {Visited, Path} = VandP,
    Was_Visited = array:get(V, Visited),
    if
        not Was_Visited ->
            Walker = fun(X, Acc) -> processDepthFirst(Maze, V, X, Acc) end,
            Random_Neighbours = shuffle(digraph:out_neighbours(Maze#maze.g, V), []),
            lists:foldl(Walker, {array:set(V, true, Visited), Path++[{Vfrom, V}]}, Random_Neighbours);
        true -> VandP
    end.

open_wall(_, {-1, _}) -> ok;
open_wall(Maze, {V, V2}) ->
    case (V2 > V) of true -> digraph:add_edge(Maze#maze.g, V, V2); _Else -> digraph:add_edge(Maze#maze.g, V2, V) end.

generate_MxN(M, N) ->
    Maze = make_maze(M, N),
    Matrix = make_maze(M, N, all_connected),
    Trail = processDepthFirst(Matrix),
    lists:foreach(fun(X) -> open_wall(Maze, X) end, Trail),
    Parts = maze_parts(Maze),
    lists:foreach(fun(X) -> draw_part(X) end, Parts).

generate_default() ->
    generate_MxN(9, 9).
