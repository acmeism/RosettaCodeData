with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Long_Float_Text_IO; use Ada.Long_Float_Text_IO;

procedure Euler is
   Epsilon : constant     := 1.0E-15;
   Fact    : Long_Integer := 1;
   E       : Long_Float   := 2.0;
   E0      : Long_Float   := 0.0;
   N       : Long_Integer := 2;

begin

   loop
      E0   := E;
      Fact := Fact * N;
      N    := N + 1;
      E    := E + (1.0 / Long_Float (Fact));
      exit when abs (E - E0) < Epsilon;
   end loop;

   Put ("e = ");
   Put (E, 0, 15, 0);
   New_Line;

end Euler;
