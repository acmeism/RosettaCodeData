with Ada.Text_IO, Ada.Command_Line, String_Helper;

procedure Madlib is

   use String_Helper;

   Text: Vector := Get_Vector(Ada.Command_Line.Argument(1));
   M, N: Natural;

begin
   -- search for templates and modify the text accordingly
   for I in Text.First_Index .. Text.Last_Index loop
      loop
         Search_Brackets(Text.Element(I), "<", ">", M, N);
      exit when M=0; -- "M=0" means "not found"
         Ada.Text_IO.Put_Line("Replacement for " & Text.Element(I)(M .. N) & "?");
         declare
            Old: String := Text.Element(I)(M .. N);
            New_Word: String := Ada.Text_IO.Get_Line;
         begin
            for J in I .. Text.Last_Index loop
               Text.Replace_Element(J, Replace(Text.Element(J), Old, New_Word));
            end loop;
         end;
      end loop;
   end loop;

   -- write the text
   for I in Text.First_Index .. Text.Last_Index loop
      Ada.Text_IO.Put_Line(Text.Element(I));
   end loop;
end Madlib;
