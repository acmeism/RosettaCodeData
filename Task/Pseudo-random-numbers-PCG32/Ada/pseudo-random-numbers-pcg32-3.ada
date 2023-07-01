with Ada.Text_Io; use ADa.Text_io;
with Interfaces; use Interfaces;
with random_pcg32; use random_pcg32;

procedure Main_P is
   counts : array (0..4) of Natural := (Others => 0);
   J : Natural;
begin
   seed(42, 54);
   for I in 1..5 loop
      Put_Line(Unsigned_32'Image(Next_Int));
   end loop;
   New_Line;

   seed(987654321, 1);
   for I in 1..100_000 loop
      J := Natural(Long_Float'Floor(Next_Float * 5.0));
      Counts(J) := Counts(J) + 1;
   end loop;

   for I in Counts'Range loop
      Put_Line(I'Image & " :" & Counts(I)'Image);
   end loop;

end Main_P;
