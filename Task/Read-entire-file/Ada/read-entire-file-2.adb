with Ada.Text_IO,
     POSIX.IO,
     POSIX.Memory_Mapping,
     System.Storage_Elements;

procedure Read_Entire_File is

   use POSIX, POSIX.IO, POSIX.Memory_Mapping;
   use System.Storage_Elements;

   Text_File    : File_Descriptor;
   Text_Size    : System.Storage_Elements.Storage_Offset;
   Text_Address : System.Address;

begin
   Text_File := Open (Name => "read_entire_file.adb",
                      Mode => Read_Only);
   Text_Size := Storage_Offset (File_Size (Text_File));
   Text_Address := Map_Memory (Length     => Text_Size,
                               Protection => Allow_Read,
                               Mapping    => Map_Shared,
                               File       => Text_File,
                               Offset     => 0);

   declare
      Text : String (1 .. Natural (Text_Size));
      for Text'Address use Text_Address;
   begin
      Ada.Text_IO.Put (Text);
   end;

   Unmap_Memory (First  => Text_Address,
                 Length => Text_Size);
   Close (File => Text_File);
end Read_Entire_File;
