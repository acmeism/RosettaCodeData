with LZW;
with Ada.Text_IO;

procedure Test is
   package Text_IO renames Ada.Text_IO;
   package Code_IO is new Ada.Text_IO.Integer_IO (LZW.Codes);

   Test_Data : constant LZW.Compressed_Data :=
      LZW.Compress ("TOBEORNOTTOBEORTOBEORNOT");
begin
   for Index in Test_Data'Range loop
      Code_IO.Put (Test_Data (Index), 0);
      Text_IO.Put (" ");
   end loop;
   Text_IO.New_Line;
   declare
      Cleartext : constant String := LZW.Decompress (Test_Data);
   begin
      Text_IO.Put_Line (Cleartext);
   end;
end Test;
