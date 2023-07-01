with Ada.Containers.Ordered_Sets;
package body Dijkstra is

   Infinite : constant Natural := Natural'Last;

   -- ----- Graph constructor
   function Build (Edges : in t_Edges; Oriented : in Boolean := True) return t_Graph is
   begin
      return Answer : t_Graph := (others => (Neighbors => Neighbor_Lists.Empty_Map,
                                             Previous  => t_Vertex'First,
                                             Distance  => Natural'Last)) do
         for Edge of Edges loop
            Answer(Edge.From).Neighbors.Insert (Key => Edge.To, New_Item => Edge.Weight);
            if not Oriented then
               Answer(Edge.To).Neighbors.Insert (Key => Edge.From, New_Item => Edge.Weight);
            end if;
         end loop;
      end return;
   end Build;

   -- ----- Paths / distances data updating in case of computation request for a new source
   procedure Update_For_Source (Graph : in out t_Graph;
                                From  : in t_Vertex) is
      function Nearer (Left, Right : in t_Vertex) return Boolean is
        (Graph(Left).Distance < Graph(Right).Distance or else
         (Graph(Left).Distance = Graph(Right).Distance and then Left < Right));
      package Ordered is new Ada.Containers.Ordered_Sets (Element_Type => t_Vertex, "<" => Nearer);
      use Ordered;
      Remaining : Set := Empty_Set;
   begin
      -- First, let's check if vertices data are already computed for this source
      if Graph(From).Distance /= 0 then
         -- Reset distances and remaining vertices for a new source
         for Vertex in Graph'range loop
            Graph(Vertex).Distance := (if Vertex = From then 0 else Infinite);
            Remaining.Insert (Vertex);
         end loop;
         -- ----- The Dijkstra algorithm itself
         while not Remaining.Is_Empty
               -- If some targets are not connected to source, at one point, the remaining
               -- distances will all be infinite, hence the folllowing stop condition
               and then Graph(Remaining.First_Element).Distance /= Infinite loop
            declare
               Nearest : constant t_Vertex := Remaining.First_Element;
               procedure Update_Neighbor (Position : in Neighbor_Lists.Cursor) is
                  use Neighbor_Lists;
                  Neighbor     : constant t_Vertex := Key (Position);
                  In_Remaining : Ordered.Cursor    := Remaining.Find (Neighbor);
                  Try_Distance : constant Natural  :=
                    (if In_Remaining = Ordered.No_Element
                     then Infinite -- vertex already reached, this distance will fail the update test below
                     else Graph(Nearest).Distance + Element (Position));
               begin
                  if Try_Distance < Graph(Neighbor).Distance then
                     -- Update distance/path data and reorder the remaining set
                     Remaining.Delete (In_Remaining);
                     Graph(Neighbor).Distance := Try_Distance;
                     Graph(Neighbor).Previous := Nearest;
                     Remaining.Insert (Neighbor);
                  end if;
               end Update_Neighbor;
            begin
               Remaining.Delete_First;
               Graph(Nearest).Neighbors.Iterate (Update_Neighbor'Access);
            end;
         end loop;
      end if;
   end Update_For_Source;

   -- ----- Bodies for the interfaced functions
   function Shortest_Path (Graph    : in out t_Graph;
                           From, To : in t_Vertex) return t_Path is
      function Recursive_Build (From, To : in t_Vertex) return t_Path is
        (if From = To then (1 => From)
         else Recursive_Build(From, Graph(To).Previous) & (1 => To));
   begin
      Update_For_Source (Graph, From);
      if Graph(To).Distance = Infinite then
         raise Constraint_Error with "No path from " & From'Img & " to " & To'Img;
      end if;
      return Recursive_Build (From, To);
   end Shortest_Path;

   function Distance (Graph    : in out t_Graph;
                      From, To : in t_Vertex) return Natural is
   begin
      Update_For_Source (Graph, From);
      return Graph(To).Distance;
   end Distance;

end Dijkstra;
