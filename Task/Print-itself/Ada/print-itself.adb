-- Print the program's source to standard output
-- J. Carter     2023 Apr
-- Apparently it's acceptable to open the source file and copy it to the output

with Ada.Text_IO;

procedure Autoprint is
   Source : Ada.Text_IO.File_Type;
begin -- Autoprint
   Ada.Text_IO.Open (File => Source, Mode => Ada.Text_IO.In_File, Name => "autoprint.adb");

   All_Lines : loop
      exit All_Lines when Ada.Text_IO.End_Of_File (Source);

      Ada.Text_IO.Put_Line (Item => Ada.Text_IO.Get_Line (Source) );
   end loop All_Lines;

   Ada.Text_IO.Close (File => Source);
end Autoprint;
