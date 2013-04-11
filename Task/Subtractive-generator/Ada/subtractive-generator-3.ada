with Ada.Text_IO;
with Subtractive_Generator;

procedure Main is
   Random : Subtractive_Generator.State;
   N      : Natural;
begin
   Subtractive_Generator.Initialize (Generator => Random,
                                     Seed      => 292929);
   for I in 220 .. 222 loop
      Subtractive_Generator.Next (Generator => Random, N => N);
      Ada.Text_IO.Put_Line (Integer'Image (I) & ":" & Integer'Image (N));
   end loop;
end Main;
