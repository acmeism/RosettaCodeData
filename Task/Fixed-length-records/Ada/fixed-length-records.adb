with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   subtype Block is String (1 .. 80);
   Infile_Name  : String := "infile.dat";
   outfile_Name : String := "outfile.dat";
   Infile       : File_Type;
   outfile      : File_Type;

   Line : Block := (Others => ' ');
begin
   Open (File => Infile, Mode => In_File, Name => Infile_Name);
   Create (File => outfile, Mode => Out_File, Name => outfile_Name);

   Put_Line("Input data:");
   New_Line;
   while not End_Of_File (Infile) loop
      Get (File => Infile, Item => Line);
      Put(Line);
      New_Line;
      for I in reverse Line'Range loop
         Put (File => outfile, Item => Line (I));
      end loop;
   end loop;

   Close (Infile);
   Close (outfile);

   Open(File => infile,
        Mode => In_File,
        Name => outfile_name);
   New_Line;
   Put_Line("Output data:");
   New_Line;
   while not End_Of_File(Infile) loop
      Get(File => Infile,
          Item => Line);
      Put(Line);
      New_Line;
   end loop;
end Main;
