with Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Range_Consolidation is

   type Set_Type is record
      Left, Right : Float;
   end record;

   package Set_Vectors is
      new Ada.Containers.Vectors (Positive, Set_Type);

   procedure Normalize (Set : in out Set_Vectors.Vector) is

      function Less_Than (Left, Right : Set_Type) return Boolean is
         begin Return Left.Left < Right.Left; end;

      package Set_Sorting is
         new Set_Vectors.Generic_Sorting (Less_Than);
   begin
      for Elem of Set loop
         Elem := (Left  => Float'Min (Elem.Left,  Elem.Right),
                  Right => Float'Max (Elem.Left,  Elem.Right));
      end loop;
      Set_Sorting.Sort (Set);
   end Normalize;

   procedure Consolidate (Set : in out Set_Vectors.Vector) is
      use Set_Vectors;
      First : Cursor := Set.First;
      Last  : Cursor := Next (First);
   begin
      while Last /= No_Element loop
         if Element (First).Right < Element (Last).Left then      -- non-overlap
            First := Last;
            Last  := Next (Last);
         elsif Element (First).Right >= Element (Last).Left then  -- overlap
            Replace_Element (Set, First, (Left  => Element (First).Left,
                                          Right => Float'Max (Element (First).Right,
                                                              Element (Last) .Right)));
            Delete (Set, Last);
            Last := Next (First);
         end if;
      end loop;
   end Consolidate;

   procedure Put (Set : in Set_Vectors.Vector) is
      package Float_IO is
         new Ada.Text_IO.Float_IO (Float);
   begin
      Float_IO.Default_Exp  := 0;
      Float_IO.Default_Aft  := 1;
      Float_IO.Default_Fore := 3;
      for Elem of Set loop
         Ada.Text_IO.Put ("(");
         Float_IO.Put (Elem.Left);
         Float_IO.Put (Elem.Right);
         Ada.Text_IO.Put (") ");
      end loop;
   end Put;

   procedure Show (Set : in out Set_Vectors.Vector) is
      use Ada.Text_IO;
   begin
      Put (Set);
      Normalize (Set);
      Consolidate (Set);
      Set_Col (70);
      Put (Set);
      New_Line;
   end Show;

   use Set_Vectors;
   Set_0 : Set_Vectors.Vector := Empty_Vector;
   Set_1 : Set_Vectors.Vector := Empty_Vector & (1.1, 2.2);
   Set_2 : Set_Vectors.Vector := (6.1, 7.2) & (7.2, 8.3);
   Set_3 : Set_Vectors.Vector := (4.0, 3.0) & (2.0, 1.0);
   Set_4 : Set_Vectors.Vector := (4.0, 3.0) & (2.0, 1.0) & (-1.0, -2.0) & (3.9, 10.0);
   Set_5 : Set_Vectors.Vector := (1.0, 3.0) & (-6.0, -1.0) & (-4.0, -5.0) & (8.0, 2.0) & (-6.0, -6.0);
begin
   Show (Set_0);
   Show (Set_1);
   Show (Set_2);
   Show (Set_3);
   Show (Set_4);
   Show (Set_5);
end Range_Consolidation;
