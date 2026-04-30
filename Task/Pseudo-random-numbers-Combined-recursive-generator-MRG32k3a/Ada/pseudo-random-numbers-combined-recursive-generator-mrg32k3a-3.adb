with Ada.Text_IO; use Ada.Text_IO;
with mrg32ka; use mrg32ka;

procedure Main is
   counts : array(0..4) of Natural := (Others => 0);
   J : Natural;
begin

   seed(1234567);
   for I in 1..5 loop
      Put_Line(I64'Image(Next_Int));
   end loop;
   New_Line;
   seed(987654321);

   for I in 1..100_000 loop
      J := Natural(Long_Float'Floor(Next_Float * 5.0));
      Counts(J) := Counts(J) + 1;
   end loop;

   for I in Counts'Range loop
      Put(I'Image & " :" & Counts(I)'Image);
   end loop;

end Main;
