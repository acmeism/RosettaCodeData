with Ada.Text_IO;
with Moving;
procedure Main is
   package Three_Average is new Moving (Max_Elements => 3, Number => Float);
   package Five_Average is new Moving (Max_Elements => 5, Number => Float);
begin
   for I in 1 .. 5 loop
      Ada.Text_IO.Put_Line ("Inserting" & Integer'Image (I) &
        " into max-3: " & Float'Image (Three_Average.Moving_Average (Float (I))));
      Ada.Text_IO.Put_Line ("Inserting" & Integer'Image (I) &
        " into max-5: " & Float'Image (Five_Average.Moving_Average (Float (I))));
   end loop;
   for I in reverse 1 .. 5 loop
      Ada.Text_IO.Put_Line ("Inserting" & Integer'Image (I) &
        " into max-3: " & Float'Image (Three_Average.Moving_Average (Float (I))));
      Ada.Text_IO.Put_Line ("Inserting" & Integer'Image (I) &
        " into max-5: " & Float'Image (Five_Average.Moving_Average (Float (I))));
   end loop;
end Main;
