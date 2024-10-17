program Rosetta_Dijkstra_Console;

{$APPTYPE CONSOLE}

uses SysUtils; // for printing the result

// Conventional values (any negative values would do)
const
  INFINITY  = -1;
  NO_VERTEX = -2;

const
  NR_VERTICES = 6;

// DISTANCE_MATRIX[u, v] = length of directed edge from u to v, or -1 if no such edge exists.
// A simple way to represent a directed graph with not many vertices.
const DISTANCE_MATRIX : array [0..(NR_VERTICES - 1), 0..(NR_VERTICES - 1)] of integer
= ((-1,  7,  9, -1, -1, -1),
   (-1, -1, 10, 15, -1, -1),
   (-1, -1, -1, 11, -1,  2),
   (-1, -1, -1, -1,  6, -1),
   (-1, -1, -1, -1, -1,  9),
   (-1, -1, -1, -1, -1, -1));

type TVertex = record
  Distance : integer; // distance from vertex 0; infinity if a path has not yet been found
  Previous : integer; // previous vertex in the path from vertex 0
  Visited  : boolean; // as defined in the algorithm
end;

// For distances x and y, test whether x < y, using the convention that -1 means infinity.
function IsLess( x, y : integer) : boolean;
begin
  result := (x <> INFINITY)
        and ( (y = INFINITY) or (x < y) );
end;

// Main routine
var
  v : array [0..NR_VERTICES - 1] of TVertex; // array of vertices
  c : integer; // index of current vertex
  j : integer; // loop counter
  trialDistance : integer;
  minDistance : integer;
  // Variables for printing the result
  p : integer;
  lineOut : string;
begin
  // Initialize the vertices
  for j := 0 to NR_VERTICES - 1 do begin
    v[j].Distance := INFINITY;
    v[j].Previous := NO_VERTEX;
    v[j].Visited  := false;
  end;

  // Start with vertex 0 as the current vertex
  c := 0;
  v[c].Distance := 0;

  // Main loop of Dijkstra's algorithm
  repeat

    // Work through unvisited neighbours of the current vertex, updating them where possible.
    // "Neighbour" means the end of a directed edge from the current vertex.
    // Note that v[c].Distance is always finite.
    for j := 0 to NR_VERTICES - 1 do begin
      if (not v[j].Visited) and (DISTANCE_MATRIX[c, j] >= 0) then begin
        trialDistance := v[c].Distance + DISTANCE_MATRIX[c, j];
        if IsLess( trialDistance, v[j].Distance) then begin
          v[j].Distance := trialDistance;
          v[j].Previous := c;
        end;
      end;
    end;

    // When all neighbours have been tested, mark the current vertex as visited.
    v[c].Visited := true;

    // The new current vertex is the unvisited vertex with the smallest finite distance.
    // If there is no such vertex, the algorithm is finished.
    c := NO_VERTEX;
    minDistance := INFINITY;
    for j := 0 to NR_VERTICES - 1 do begin
      if (not v[j].Visited) and IsLess( v[j].Distance, minDistance) then begin
        minDistance := v[j].Distance;
        c := j;
      end;
    end;
  until (c = NO_VERTEX);

  // Print the result
  for j := 0 to NR_VERTICES - 1 do begin
    if (v[j].Distance = INFINITY) then begin
      // The algorithm never found a path to v[j]
      lineOut := SysUtils.Format( '%2d: inaccessible', [j]);
    end
    else begin
      // Build up the path of vertices, working backwards from v[j]
      lineOut := SysUtils.Format( '%2d', [j]);
      p := v[j].Previous;
      while (p <> NO_VERTEX) do begin
        lineOut := SysUtils.Format( '%2d --> ', [p]) + lineOut;
        p := v[p].Previous;
      end;
      // Print the path of vertices, preceded by distance from vertex 0
      lineOut := SysUtils.Format( '%2d: distance = %3d, ', [j, v[j].Distance]) + lineOut;
    end;
    WriteLn( lineOut);
  end;
end.
