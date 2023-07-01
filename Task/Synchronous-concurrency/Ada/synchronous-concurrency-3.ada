with Synchronous_Concurrent; use Synchronous_Concurrent;
with Ada.Text_Io; use Ada.Text_Io;

procedure Synchronous_Concurrent_Main is
   Num_Strings : Natural;
   The_File : File_Type;
   Line : String(1..255);
   Length : Natural;
begin
   Open(File => The_File, Mode => In_File, Name => "input.txt");
   while not End_Of_File(The_File) loop
      Get_Line(File => The_File, Item => Line, Last => Length);
      Printer.Put(Line(1..Length));
   end loop;
   Close(The_File);
   Printer.Get_Count(Num_Strings);
   New_Line;
   Put_Line("The task wrote" & Natural'Image(Num_Strings) & " strings.");
end Synchronous_Concurrent_Main;
