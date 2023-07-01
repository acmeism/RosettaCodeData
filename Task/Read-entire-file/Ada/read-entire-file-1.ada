with Ada.Directories,
     Ada.Direct_IO,
     Ada.Text_IO;

procedure Whole_File is

   File_Name : String  := "whole_file.adb";
   File_Size : Natural := Natural (Ada.Directories.Size (File_Name));

   subtype File_String    is String (1 .. File_Size);
   package File_String_IO is new Ada.Direct_IO (File_String);

   File     : File_String_IO.File_Type;
   Contents : File_String;

begin
   File_String_IO.Open  (File, Mode => File_String_IO.In_File,
                               Name => File_Name);
   File_String_IO.Read  (File, Item => Contents);
   File_String_IO.Close (File);

   Ada.Text_IO.Put (Contents);
end Whole_File;
