with Interfaces;        use Interfaces;
with Random_Splitmix64; use Random_Splitmix64;
with Ada.Text_IO;       use Ada.Text_IO;

procedure Main is
   subtype idx is Integer range 0 .. 4;
   type answer_arr is array (idx) of Natural;
   Vec : answer_arr := (others => 0);
   J   : Integer;
   fj  : Float;
begin
   Set_State (1_234_567);
   for I in 1 .. 5 loop
      Put (Unsigned_64'Image (next_Int));
      New_Line;
   end loop;

   Set_State (987_654_321);

   for I in 1 .. 100_000 loop
      fj      := Float'Truncation (next_float * 5.0);
      J       := Integer (fj);
      Vec (J) := Vec (J) + 1;
   end loop;

   for I in Vec'Range loop
      Put_Line (I'Image & ":" & Integer'Image (Vec (I)));
   end loop;

end Main;
