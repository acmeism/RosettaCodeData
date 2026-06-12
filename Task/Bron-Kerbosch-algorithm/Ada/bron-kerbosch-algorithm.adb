pragma Ada_2022;
with Ada.Text_IO;  use Ada.Text_IO;

with Generic_Address_Order;
with Generic_Undirected_Graph;
with Generic_Unbounded_Array;

procedure Bron_Kerbosch is
   generic
      with package Graphs is new Generic_Undirected_Graph (<>);
   package Graph_Cliques is
      use Graphs;
      type Node_Set_Array is array (Positive range <>) of Node_Sets.Set;
      function Bron_Kerbosch (G : Nodes_Array) return Node_Set_Array;
   end Graph_Cliques;

   package body Graph_Cliques is
      use Node_Sets;
      package Node_Set_Arrays is
         new Generic_Unbounded_Array
             (  Index_Type        => Positive,
                Object_Type       => Set,
                Object_Array_Type => Node_Set_Array,
                Null_Element      => Node_Sets.Create
             );

      function Bron_Kerbosch (G : Nodes_Array) return Node_Set_Array is
         use Node_Set_Arrays;
         Cliques : Node_Set_Arrays.Unbounded_Array;
         Count   : Natural := 0;
         Size    : Natural := 2;
         P, R, X : Set;

         procedure Internal (R, P, X : in out Set) is
            Pivot : Node;
            Max   : Integer := -1;
         begin
            if P.Is_Empty and then X.Is_Empty then
               declare
                  New_Size : constant Natural := R.Get_Size;
               begin
                  if New_Size >= Size then
                     if New_Size > Size then
                        Count := 1;
                     else
                        Count := Count + 1;
                     end if;
                     Cliques.Put (Count, R);
                     Size := New_Size;
                     return;
                  end if;
               end;
            end if;
            for Index in 1..P.Get_Size loop
               if Get_Adjacent_Number (P.Get (Index)) > Max then
                  Pivot := P.Get (Index);
                  Max   := Get_Adjacent_Number (Pivot);
               end if;
            end loop;
            for Index in 1..X.Get_Size loop
               if Get_Adjacent_Number (X.Get (Index)) > Max then
                  Pivot := X.Get (Index);
                  Max   := Get_Adjacent_Number (Pivot);
               end if;
            end loop;
            for Index in reverse 1..P.Get_Size loop
               declare
                  V : constant Node := P.Get (Index);
               begin
                  if not Related (V, Pivot) then
                     declare
                        R1 : Set := R;
                        P1 : Set := P and Get_Adjacent (V);
                        X1 : Set := X and Get_Adjacent (V);
                     begin
                        R1.Add (V);
                        Internal (R1, P1, X1);
                        Remove (P, V);
                        X.Add (V);
                     end;
                  end if;
               end;
            end loop;
         end Internal;
      begin
         for I in G'Range loop
            P.Add (G (I));
         end loop;
         Internal (R, P, X);
         if Count > 0 then
            return Cliques.Vector (1..Count);
         else
            return (1..0 => Create);
         end if;
      end Bron_Kerbosch;
   end Graph_Cliques;

   type Default is access Character;
   package Order is new Generic_Address_Order (Character);
   use Order;

   package Graphs is
      new Generic_Undirected_Graph (Character, Default'Storage_Pool);
   use Graphs;
   package Cliques is new Graph_Cliques (Graphs);
   use Cliques;

   procedure Print (S : Node_Sets.Set) is
   begin
      for I in 1..S.Get_Size loop
         if I > 1 then
            Put (", ");
         end if;
         Put (S.Get (I).all);
      end loop;
      New_Line;
   end Print;

   G : constant Nodes_Array := -- Vertices 'A'..'F';
       (  for I in 1..6 =>
             new Character'(Character'Val (I + Character'Pos ('A') - 1))
       );
begin
   Connect (G (1), G (2)); -- Connecting vertices
   Connect (G (1), G (3));
   Connect (G (2), G (3));
   Connect (G (4), G (5));
   Connect (G (4), G (6));
   Connect (G (6), G (5));
   declare
      Cliques : constant Node_Set_Array := Bron_Kerbosch (G);
   begin
      Put_Line ("Maximal cliques:");
      for I in Cliques'Range loop
         Print (Cliques (I));
      end loop;
   end;
end Bron_Kerbosch;
