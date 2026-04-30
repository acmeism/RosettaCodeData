--
-- Floyd-Warshall algorithm.
--
-- See https://en.wikipedia.org/w/index.php?title=Floyd%E2%80%93Warshall_algorithm&oldid=1082310013
--

with Ada.Containers.Vectors;
with Ada.Text_IO; use Ada.Text_IO;
with Interfaces;  use Interfaces;

with Ada.Numerics.Generic_Elementary_Functions;

procedure floyd_warshall_task
is
  Floyd_Warshall_Exception : exception;

  -- The floating point type we shall use is one that has infinities.
  subtype FloatPt is IEEE_Float_32;
  package FloatPt_Elementary_Functions is new Ada.Numerics
   .Generic_Elementary_Functions
   (FloatPt);
  use FloatPt_Elementary_Functions;

  -- The following should overflow and give us an IEEE infinity. But I
  -- have kept the code so you could use some non-IEEE floating point
  -- format and set ENORMOUS_FloatPt to some value that is finite but
  -- much larger than actual graph traversal distances.
  ENORMOUS_FloatPt : constant FloatPt :=
   (FloatPt (1.0) / FloatPt (1.0e-37))**1.0e37;

  --
  -- Input is a Vector of records representing the edges of a graph.
  --
  -- Vertices are identified by integers from 1 .. n.
  --

  type edge is record
    u      : Positive;
    weight : FloatPt;
    v      : Positive;
  end record;

  package Edge_Vectors is new Ada.Containers.Vectors
   (Index_Type => Positive, Element_Type => edge);
  use Edge_Vectors;
  subtype edge_vector is Edge_Vectors.Vector;

  --
  -- Floyd-Warshall.
  --

  type distance_array is
   array (Positive range <>, Positive range <>) of FloatPt;

  type next_vertex_array is
   array (Positive range <>, Positive range <>) of Natural;
  Nil_Vertex : constant Natural := 0;

  function find_max_vertex      -- Find the maximum vertex number.
   (edges : in edge_vector)
    return Positive
  is
    max_vertex : Positive;
  begin
    if Is_Empty (edges) then
      raise Floyd_Warshall_Exception with "no edges";
    end if;
    max_vertex := 1;
    for i in edges.First_Index .. edges.Last_Index loop
      max_vertex := Positive'Max (max_vertex, edges.Element (i).u);
      max_vertex := Positive'Max (max_vertex, edges.Element (i).v);
    end loop;
    return max_vertex;
  end find_max_vertex;

  procedure floyd_warshall      -- Perform Floyd-Warshall.
   (edges       : in     edge_vector;
    max_vertex  : in     Positive;
    distance    :    out distance_array;
    next_vertex :    out next_vertex_array)
  is
    u, v     : Positive;
    dist_ikj : FloatPt;
  begin

    -- Initialize.

    for i in 1 .. max_vertex loop
      for j in 1 .. max_vertex loop
        distance (i, j)    := ENORMOUS_FloatPt;
        next_vertex (i, j) := Nil_Vertex;
      end loop;
    end loop;
    for i in edges.First_Index .. edges.Last_Index loop
      u                  := edges.Element (i).u;
      v                  := edges.Element (i).v;
      distance (u, v)    := edges.Element (i).weight;
      next_vertex (u, v) := v;
    end loop;
    for i in 1 .. max_vertex loop
      distance (i, i) :=
       FloatPt (0.0);           -- Distance from a vertex to itself.
      next_vertex (i, i) := i;
    end loop;

    -- Perform the algorithm.

    for k in 1 .. max_vertex loop
      for i in 1 .. max_vertex loop
        for j in 1 .. max_vertex loop
          dist_ikj := distance (i, k) + distance (k, j);
          if dist_ikj < distance (i, j) then
            distance (i, j)    := dist_ikj;
            next_vertex (i, j) := next_vertex (i, k);
          end if;
        end loop;
      end loop;
    end loop;

  end floyd_warshall;

  --
  -- Path reconstruction.
  --

  procedure put_path
   (next_vertex : in next_vertex_array;
    u, v        : in Positive)
  is
    i : Positive;
  begin
    if next_vertex (u, v) /= Nil_Vertex then
      i := u;
      Put (Positive'Image (i));
      while i /= v loop
        Put (" ->");
        i := next_vertex (i, v);
        Put (Positive'Image (i));
      end loop;
    end if;
  end put_path;

  example_graph : edge_vector;
  max_vertex    : Positive;

begin
  Append (example_graph, (u => 1, weight => FloatPt (-2.0), v => 3));
  Append (example_graph, (u => 3, weight => FloatPt (+2.0), v => 4));
  Append (example_graph, (u => 4, weight => FloatPt (-1.0), v => 2));
  Append (example_graph, (u => 2, weight => FloatPt (+4.0), v => 1));
  Append (example_graph, (u => 2, weight => FloatPt (+3.0), v => 3));

  max_vertex := find_max_vertex (example_graph);

  declare

    distance    : distance_array (1 .. max_vertex, 1 .. max_vertex);
    next_vertex : next_vertex_array
     (1 .. max_vertex, 1 .. max_vertex);

  begin

    floyd_warshall (example_graph, max_vertex, distance, next_vertex);

    Put_Line ("  pair       distance        path");
    Put_Line ("---------------------------------------------");
    for u in 1 .. max_vertex loop
      for v in 1 .. max_vertex loop
        if u /= v then
          Put (Positive'Image (u));
          Put (" ->");
          Put (Positive'Image (v));
          Put ("    ");
          Put (FloatPt'Image (distance (u, v)));
          Put ("    ");
          put_path (next_vertex, u, v);
          Put_Line ("");
        end if;
      end loop;
    end loop;

  end;
end floyd_warshall_task;
