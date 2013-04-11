MazeGraph[m_, n_] :=
  Block[{$RecursionLimit = Infinity, grid = GridGraph[{m, n}],
    visited = {}},
   Graph[Range[m n], Reap[{AppendTo[visited, #];
         Do[
          If[FreeQ[visited, neighbor],
           Sow[# <-> neighbor]; #0@neighbor], {neighbor,
           RandomSample@AdjacencyList[grid, #]}]} &@
       RandomChoice@VertexList@grid][[2, 1]],
    GraphLayout -> {"GridEmbedding", "Dimension" -> {m, n}}]];
maze = MazeGraph[13, 21]
