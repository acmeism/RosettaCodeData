program HopcroftKarp;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, fgl;

const
  NIL_VERTEX = 0;
  INFINITE_LEVEL = MaxInt;

type
  // Edge structure
  TEdge = record
    from, to_: Integer;
  end;

  // Dynamic array of integers
  TIntArray = array of Integer;

  // Dynamic array of integer arrays
  TIntArray2D = array of TIntArray;

  // Bipartite graph class
  TBipartiteGraph = class
  private
    m, n: Integer;                           // Size of partitions
    adjacency_lists: TIntArray2D;            // Adjacency lists for U vertices
    pair_u, pair_v: TIntArray;               // Matching pairs
    levels: TIntArray;                       // BFS levels

    // Helper methods
    function BreadthFirstSearch: Boolean;
    function DepthFirstSearch(u: Integer): Boolean;

  public
    constructor Create(aM, aN: Integer);
    procedure AddEdge(u, v: Integer);
    function HopcroftKarpAlgorithm: Integer;
  end;

constructor TBipartiteGraph.Create(aM, aN: Integer);
begin
  m := aM;
  n := aN;

  // Initialize adjacency lists
  SetLength(adjacency_lists, m + 1);

  // Initialize matching arrays
  SetLength(pair_u, m + 1);
  SetLength(pair_v, n + 1);

  // Initialize levels array
  SetLength(levels, m + 1);
end;

procedure TBipartiteGraph.AddEdge(u, v: Integer);
begin
  if (u >= 1) and (u <= m) and (v >= 1) and (v <= n) then
  begin
    SetLength(adjacency_lists[u], Length(adjacency_lists[u]) + 1);
    adjacency_lists[u][High(adjacency_lists[u])] := v;
  end
  else
  begin
    raise Exception.Create('Attempt to add an edge (' +
                          IntToStr(u) + ', ' + IntToStr(v) +
                          ') which is out of bounds');
  end;
end;

function TBipartiteGraph.HopcroftKarpAlgorithm: Integer;
var
  u: Integer;
  matching_size: Integer;
begin
  // Initialize matching
  for u := 0 to m do
    pair_u[u] := NIL_VERTEX;
  for u := 0 to n do
    pair_v[u] := NIL_VERTEX;

  matching_size := 0;

  while BreadthFirstSearch do
  begin
    for u := 1 to m do
    begin
      if (pair_u[u] = NIL_VERTEX) and DepthFirstSearch(u) then
      begin
        Inc(matching_size);
      end;
    end;
  end;

  Result := matching_size;
end;

function TBipartiteGraph.BreadthFirstSearch: Boolean;
var
  queue: specialize TFPGList<Integer>;
  u, v, matched_u, i: Integer;
begin
  queue := specialize TFPGList<Integer>.Create;
  try
    // Initialize levels for vertices in U
    for u := 1 to m do
    begin
      if pair_u[u] = NIL_VERTEX then
      begin
        levels[u] := 0;
        queue.Add(u);
      end
      else
      begin
        levels[u] := INFINITE_LEVEL;
      end;
    end;

    // Level of NIL represents shortest augmenting path length
    levels[NIL_VERTEX] := INFINITE_LEVEL;

    while queue.Count > 0 do
    begin
      u := queue[0];
      queue.Delete(0);

      if levels[u] < levels[NIL_VERTEX] then
      begin
        // Explore neighbors v of u in V
        for i := 0 to High(adjacency_lists[u]) do
        begin
          v := adjacency_lists[u][i];
          matched_u := pair_v[v];

          if levels[matched_u] = INFINITE_LEVEL then
          begin
            levels[matched_u] := levels[u] + 1;
            queue.Add(matched_u);
          end;
        end;
      end;
    end;

    Result := (levels[NIL_VERTEX] <> INFINITE_LEVEL);
  finally
    queue.Free;
  end;
end;

function TBipartiteGraph.DepthFirstSearch(u: Integer): Boolean;
var
  v, matched_u, i: Integer;
begin
  if u <> NIL_VERTEX then
  begin
    // Explore neighbors v of u in V
    for i := 0 to High(adjacency_lists[u]) do
    begin
      v := adjacency_lists[u][i];
      matched_u := pair_v[v];

      // Check if edge leads to a vertex on shortest augmenting path
      if levels[matched_u] = levels[u] + 1 then
      begin
        if DepthFirstSearch(matched_u) then
        begin
          pair_v[v] := u;
          pair_u[u] := v;
          Result := True;
          Exit;
        end;
      end;
    end;

    // No augmenting path found, remove from DFS
    levels[u] := INFINITE_LEVEL;
    Result := False;
  end
  else
  begin
    // NIL vertex reached, augmenting path found
    Result := True;
  end;
end;

// Test function
function TestValue(testNumber, m, n: Integer; edges: array of TEdge; expected_result: Integer): Integer;
var
  graph: TBipartiteGraph;
  i: Integer;
  result_value: Integer;
begin
  graph := TBipartiteGraph.Create(m, n);
  try
    for i := 0 to High(edges) do
    begin
      graph.AddEdge(edges[i].from, edges[i].to_);
    end;

    result_value := graph.HopcroftKarpAlgorithm;
    WriteLn('Test ', testNumber, ': Result = ', result_value, ', Expected = ', expected_result);

    if result_value = expected_result then
    begin
      Result := 1;
    end
    else
    begin
      WriteLn('Test ', testNumber, ' failed.');
      Result := 0;
    end;
  finally
    graph.Free;
  end;
end;

// Main procedure
var
  success_count: Integer;
  edges: array of TEdge;
  i, j, idx: Integer;

begin
  WriteLn('Running tests:');
  success_count := 0;

  // Test Case 1
  SetLength(edges, 1);
  edges[0].from := 1;
  edges[0].to_ := 4;
  success_count := success_count + TestValue(1, 3, 5, edges, 1);

  // Test Case 2
  SetLength(edges, 3);
  edges[0].from := 1;
  edges[0].to_ := 4;
  edges[1].from := 1;
  edges[1].to_ := 5;
  edges[2].from := 5;
  edges[2].to_ := 1;
  success_count := success_count + TestValue(2, 6, 6, edges, 2);

  // Test Case 3: Complete Bipartite Graph K(3, 3)
  SetLength(edges, 9);
  idx := 0;
  for i := 1 to 3 do
  begin
    for j := 1 to 3 do
    begin
      edges[idx].from := i;
      edges[idx].to_ := j;
      Inc(idx);
    end;
  end;
  success_count := success_count + TestValue(3, 3, 3, edges, 3);

  // Test Case 4: No edges
  SetLength(edges, 0);
  success_count := success_count + TestValue(4, 2, 2, edges, 0);

  // Test Case 5
  SetLength(edges, 6);
  edges[0].from := 1;
  edges[0].to_ := 1;
  edges[1].from := 1;
  edges[1].to_ := 3;
  edges[2].from := 2;
  edges[2].to_ := 3;
  edges[3].from := 3;
  edges[3].to_ := 4;
  edges[4].from := 4;
  edges[4].to_ := 3;
  edges[5].from := 4;
  edges[5].to_ := 2;
  success_count := success_count + TestValue(5, 4, 4, edges, 4);

  if success_count = 5 then
  begin
    WriteLn('All tests passed.');
  end;
end.
