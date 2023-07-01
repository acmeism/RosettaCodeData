with Ada.Strings.Fixed;
with Ada.Text_IO;
with Templates_Parser;

procedure Csv2Html is
   use type Templates_Parser.Vector_Tag;

   Chars : Templates_Parser.Vector_Tag;
   Speeches : Templates_Parser.Vector_Tag;

   CSV_File : Ada.Text_IO.File_Type;
begin
   -- read the csv data
   Ada.Text_IO.Open (File => CSV_File,
                     Mode => Ada.Text_IO.In_File,
                     Name => "data.csv");

   -- fill the tags
   while not Ada.Text_IO.End_Of_File (CSV_File) loop
      declare
         Whole_Line : String := Ada.Text_IO.Get_Line (CSV_File);
         Comma_Pos : Natural := Ada.Strings.Fixed.Index (Whole_Line, ",");
      begin
         Chars := Chars & Whole_Line (Whole_Line'First .. Comma_Pos - 1);
         Speeches := Speeches & Whole_Line (Comma_Pos + 1 .. Whole_Line'Last);
      end;
   end loop;

   Ada.Text_IO.Close (CSV_File);

   -- build translation table and output html
   declare
      Translations : constant Templates_Parser.Translate_Table :=
        (1 => Templates_Parser.Assoc ("CHAR", Chars),
         2 => Templates_Parser.Assoc ("SPEECH", Speeches));
   begin
      Ada.Text_IO.Put_Line
        (Templates_Parser.Parse ("table.tmplt", Translations));
   end;
end Csv2Html;
