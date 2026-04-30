with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   type long is range 0 .. 2**64;
   Seed : long := 675_248;
   function random return long is
   begin
      Seed := Seed * Seed / 1_000 rem 1_000_000;
      return Seed;
   end random;
begin
   for I in 1 .. 5 loop
      Put (long'Image (random));
   end loop;
   New_Line;
end Main;
