with Interfaces;  use Interfaces;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   const : constant Unsigned_64 := 16#2545_F491_4F6C_DD1D#;
   state : Unsigned_64          := 0;
   Unseeded_Error : exception;

   procedure seed (num : Unsigned_64) is
   begin
      state := num;
   end seed;

   function Next_Int return Unsigned_32 is
      x : Unsigned_64 := state;
   begin
      if state = 0 then
         raise Unseeded_Error;
      end if;

      x     := x xor (x / 2**12);
      x     := x xor (x * 2**25);
      x     := x xor (x / 2**27);
      state := x;
      return Unsigned_32 ((x * const) / 2**32);
   end Next_Int;

   function Next_Float return Long_Float is
   begin
      return Long_Float (Next_Int) / 2.0**32;
   end Next_Float;

   counts : array (0 .. 4) of Natural := (others => 0);
   J      : Natural;
begin
   seed (1_234_567);
   for I in 1 .. 5 loop
      Put_Line (Unsigned_32'Image (Next_Int));
   end loop;

   seed (987_654_321);
   for I in 1 .. 100_000 loop
      J          := Natural (Long_Float'Floor (Next_Float * 5.0));
      counts (J) := counts (J) + 1;
   end loop;

   New_Line;
   for I in counts'Range loop
      Put_Line (I'Image & " :" & counts (I)'Image);
   end loop;

end Main;
