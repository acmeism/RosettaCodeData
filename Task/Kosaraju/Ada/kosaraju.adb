pragma Ada_2022;
with Ada.Text_IO;  use Ada.Text_IO;

with Generic_Directed_Graph;
with Generic_Map;

procedure Kosaraju is
   generic
      with package Graph is new Generic_Directed_Graph (<>);
   package Strongly_Connected is
      use Graph;
      type Node_Set_Array is array (Positive range <>) of Node_Sets.Set;
      function Kosaraju (G : Nodes_Array) return Node_Set_Array;
   end Strongly_Connected;

   package body Strongly_Connected is
      package Node_Maps is -- Maps node->component
         new Generic_Map
             (  Key_Type    => Node,
                Object_Type => Natural,
                "="         => Same,
                "<"         => Precedes
             );
      function Kosaraju (G : Nodes_Array) return Node_Set_Array is
         L          : Nodes_Array (1..G'Length);
         Current    : Natural := 0;
         Components : Natural := 0;
         Assigned   : Node_Maps.Map;

         procedure Visit (U : Node) is
         begin
            if not Assigned.Is_In (U) then
               Assigned.Add (U, 0);
               for I in 1..Get_Children_Number (U) loop
                  Visit (Get_Child (U, I));
               end loop;
               Current := Current + 1;
               L (Current) := U;
            end if;
         end Visit;

         procedure Assign (U, Root : Node) is
         begin
            if Assigned.Get (U) = 0 then
               if Assigned.Get (Root) /= 0 then
                  Assigned.Replace (U, Assigned.Get (Root));
               else
                  Components := Components + 1; -- A new component
                  Assigned.Replace (U, Components);
               end if;
               for I in 1..Get_Parents_Number (U) loop
                  Assign (Get_Parent (U, I), Root);
               end loop;
            end if;
         end Assign;
      begin
         for I in G'Range loop -- The first pass
            Visit (G (I));
         end loop;
         for I in reverse L'Range loop -- Run the second pass
            Assign (L (I), L (I));
         end loop;
         declare -- Build strongly connected components
            Result : Node_Set_Array (1..Components);
         begin
            for I in 1..Assigned.Get_Size loop
               Result (Assigned.Get (I)).Add (Assigned.Get_Key (I));
            end loop;
            return Result;
         end;
      end Kosaraju;
   end Strongly_Connected;
--
-- Graphs with Natural vertices
--
   function Equal (Left, Right : access Natural) return Boolean is
   begin
      return Left.all = Right.all;
   end Equal;

   function Less (Left, Right : access Natural) return Boolean is
   begin
      return Left.all < Right.all;
   end Less;

   type Ptr is access Integer;
   package Graphs is
      new Generic_Directed_Graph (Natural, Ptr'Storage_Pool);
   use Graphs;
--
-- The Kosaraju instance for these graphs
--
   package Strongly_Connected_Graphs is new Strongly_Connected (Graphs);
   use Strongly_Connected_Graphs;

   procedure Print (Set : Node_Sets.Set) is
   begin
      Put ("{");
      for I in 1..Set.Get_Size loop
         if I > 1 then
            Put (",");
         end if;
         Put (Integer'Image (Set.Get (I).all));
      end loop;
      Put (" }");
      New_Line;
   end Print;

   G : Nodes_Array := (for I in 1..8 => new Natural'(I - 1));
begin
   Connect (G (1), G (2), False);
   Connect (G (2), G (3), False);
   Connect (G (3), G (1), False);
   Connect (G (4), G (2), False); Connect (G (4), G (3), False); Connect (G (4), G (5), False);
   Connect (G (5), G (4), False); Connect (G (5), G (6), False);
   Connect (G (6), G (3), False); Connect (G (6), G (7), False);
   Connect (G (7), G (6), False);
   Connect (G (8), G (5), False); Connect (G (8), G (7), False); Connect (G (8), G (8), False);
   declare
      Components : constant Node_Set_Array := Kosaraju (G);
   begin
      for I in Components'Range loop
         Print (Components (I));
      end loop;
   end;
end Kosaraju;
