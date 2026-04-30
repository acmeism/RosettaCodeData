with Ada.Text_IO;

procedure A_Plus_B is
   type Small_Integers is range -2_000 .. +2_000;
   subtype Input_Values is Small_Integers range -1_000 .. +1_000;
   package IO is new Ada.Text_IO.Integer_IO (Num => Small_Integers);
   A, B : Input_Values;
begin
   IO.Get (A);
   IO.Get (B);
   IO.Put (A + B, Width => 4, Base => 10);
end A_Plus_B;
