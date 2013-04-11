-module(topological_sort).
-compile(export_all).

-define(LIBRARIES,
        [{des_system_lib,   [std, synopsys, std_cell_lib, des_system_lib, dw02, dw01, ramlib, ieee]},
         {dw01,             [ieee, dw01, dware, gtech]},
         {dw02,             [ieee, dw02, dware]},
         {dw03,             [std, synopsys, dware, dw03, dw02, dw01, ieee, gtech]},
         {dw04,             [dw04, ieee, dw01, dware, gtech]},
         {dw05,             [dw05, ieee, dware]},
         {dw06,             [dw06, ieee, dware]},
         {dw07,             [ieee, dware]},
         {dware,            [ieee, dware]},
         {gtech,            [ieee, gtech]},
         {ramlib,           [std, ieee]},
         {std_cell_lib,     [ieee, std_cell_lib]},
         {synopsys,         []}]).

-define(BAD_LIBRARIES,
        [{des_system_lib,   [std, synopsys, std_cell_lib, des_system_lib, dw02, dw01, ramlib, ieee]},
         {dw01,             [ieee, dw01, dw04, dware, gtech]},
         {dw02,             [ieee, dw02, dware]},
         {dw03,             [std, synopsys, dware, dw03, dw02, dw01, ieee, gtech]},
         {dw04,             [dw04, ieee, dw01, dware, gtech]},
         {dw05,             [dw05, ieee, dware]},
         {dw06,             [dw06, ieee, dware]},
         {dw07,             [ieee, dware]},
         {dware,            [ieee, dware]},
         {gtech,            [ieee, gtech]},
         {ramlib,           [std, ieee]},
         {std_cell_lib,     [ieee, std_cell_lib]},
         {synopsys,         []}]).

main() ->
    top_sort(?LIBRARIES),
    top_sort(?BAD_LIBRARIES).

top_sort(Library) ->
    G = digraph:new(),
    lists:foreach(fun ({L,Deps}) ->
                          digraph:add_vertex(G,L), % noop if library already added
                          lists:foreach(fun (D) ->
                                                add_dependency(G,L,D)
                                        end, Deps)
                  end, Library),
    T = digraph_utils:topsort(G),
    case T of
        false ->
            io:format("Unsortable contains circular dependencies:~n",[]),
            lists:foreach(fun (V) ->
                                  case digraph:get_short_cycle(G,V) of
                                      false ->
                                          ok;
                                      Vs ->
                                          print_path(Vs)
                                  end
                          end, digraph:vertices(G));
        _ ->
            print_path(T)
    end.

print_path(L) ->
            lists:foreach(fun (V) -> io:format("~s -> ",[V]) end,
                          lists:sublist(L,length(L)-1)),
            io:format("~s~n",[lists:last(L)]).

add_dependency(_G,_L,_L) ->
    ok;
add_dependency(G,L,D) ->
    digraph:add_vertex(G,D), % noop if dependency already added
    digraph:add_edge(G,D,L). % Dependencies represented as an edge D -> L
