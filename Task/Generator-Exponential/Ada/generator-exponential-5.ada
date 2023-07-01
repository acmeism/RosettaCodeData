with Ada.Text_IO;
with Generator.Filtered;

procedure Generator_Test is

   function Square (X : Natural) return Natural is
   begin
      return X * X;
   end Square;

   function Cube (X : Natural) return Natural is
   begin
      return X * X * X;
   end Cube;

   G1, G2 : aliased Generator.Generator;
   F : aliased Generator.Filtered.Filtered_Generator;

begin

   G1.Set_Generator_Function (Func => Square'Unrestricted_Access);
   G2.Set_Generator_Function (Func => Cube'Unrestricted_Access);

   F.Set_Source (G1'Unrestricted_Access);
   F.Set_Filter (G2'Unrestricted_Access);

   F.Skip (20);

   for I in 1 .. 10 loop
      Ada.Text_IO.Put ("I:" & Integer'Image (I));
      Ada.Text_IO.Put (", F:" & Integer'Image (F.Get_Next));
      Ada.Text_IO.New_Line;
   end loop;

end Generator_Test;
