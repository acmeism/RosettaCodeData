with Ada.Text_IO, Mod_Inv;

procedure Chin_Rema is
   N: array(Positive range <>) of Positive := (3, 5, 7);
   A: array(Positive range <>) of Positive := (2, 3, 2);
   Tmp: Positive;
   Prod: Positive := 1;
   Sum: Natural := 0;

begin
   for I in N'Range loop
      Prod := Prod * N(I);
   end loop;

   for I in A'Range loop
      Tmp := Prod / N(I);
      Sum := Sum + A(I) * Mod_Inv.Inverse(Tmp, N(I)) * Tmp;
   end loop;
   Ada.Text_IO.Put_Line(Integer'Image(Sum mod Prod));
end Chin_Rema;
