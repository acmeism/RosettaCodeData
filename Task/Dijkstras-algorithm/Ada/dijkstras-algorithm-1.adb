private with Ada.Containers.Ordered_Maps;
generic
   type t_Vertex is (<>);
package Dijkstra is

   type t_Graph is limited private;

   -- Defining a graph (since limited private, only way to do this is to use the Build function)
   type t_Edge is record
      From, To : t_Vertex;
      Weight   : Positive;
   end record;
   type t_Edges is array (Integer range <>) of t_Edge;
   function Build (Edges : in t_Edges; Oriented : in Boolean := True) return t_Graph;

   -- Computing path and distance
   type t_Path is array (Integer range <>) of t_Vertex;
   function Shortest_Path (Graph    : in out t_Graph;
                           From, To : in t_Vertex) return t_Path;
   function Distance      (Graph    : in out t_Graph;
                           From, To : in t_Vertex) return Natural;

private
   package Neighbor_Lists is new Ada.Containers.Ordered_Maps (Key_Type => t_Vertex, Element_Type => Positive);
   type t_Vertex_Data is record
      Neighbors : Neighbor_Lists.Map; -- won't be affected after build
      -- Updated each time a function is called with a new source
      Previous  : t_Vertex;
      Distance  : Natural;
   end record;
   type t_Graph is array (t_Vertex) of t_Vertex_Data;
end Dijkstra;
