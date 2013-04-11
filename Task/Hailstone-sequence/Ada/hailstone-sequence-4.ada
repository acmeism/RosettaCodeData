with Ada.Text_IO;
with Hailstones;

procedure Main is
   package Integer_IO is new Ada.Text_IO.Integer_IO (Integer);

   procedure Print_Sequence (X : Hailstones.Integer_Sequence) is
   begin
      for I in X'Range loop
         Integer_IO.Put (Item => X (I), Width => 0);
         if I < X'Last then
            Ada.Text_IO.Put (", ");
         end if;
      end loop;
      Ada.Text_IO.New_Line;
   end Print_Sequence;

   Hailstone_27 : constant Hailstones.Integer_Sequence :=
     Hailstones.Create_Sequence (N => 27);

begin
   Ada.Text_IO.Put_Line ("Length of 27:" & Integer'Image (Hailstone_27'Length));
   Ada.Text_IO.Put ("First four: ");
   Print_Sequence (Hailstone_27 (Hailstone_27'First .. Hailstone_27'First + 3));
   Ada.Text_IO.Put ("Last four: ");
   Print_Sequence (Hailstone_27 (Hailstone_27'Last - 3 .. Hailstone_27'Last));

   declare
      Longest_Length : Natural := 0;
      Longest_N      : Positive;
      Length         : Natural;
   begin
      for I in 1 .. 99_999 loop
         Length := Hailstones.Create_Sequence (N => I)'Length;
         if Length > Longest_Length then
            Longest_Length := Length;
            Longest_N := I;
         end if;
      end loop;
      Ada.Text_IO.Put_Line ("Longest length is" & Integer'Image (Longest_Length));
      Ada.Text_IO.Put_Line ("with N =" & Integer'Image (Longest_N));
   end;
end Main;
