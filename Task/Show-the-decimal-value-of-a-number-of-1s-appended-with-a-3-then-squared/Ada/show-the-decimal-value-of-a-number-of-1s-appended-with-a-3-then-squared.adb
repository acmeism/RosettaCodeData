with Ada.Text_Io;
with Ada.Numerics.Big_Numbers.Big_Integers;

procedure Ones_Plus_Three is
   use Ada.Numerics.Big_Numbers.Big_Integers;
   use Ada.Text_Io;

   Root    : Big_Natural := 3;
   Squared : Big_Natural;
begin
   for N in 0 .. 8 loop
      Squared := Root**2;

      Put (To_String (Root, Width => 12));
      Put ("  ");
      Put (To_String (Squared, Width => 20));
      New_Line;

      Root := @ + 10**(N + 1);
   end loop;
end Ones_Plus_Three;
