with Ada.Text_IO; use Ada.Text_IO;
with GNAT.CRC32; use GNAT.CRC32;
with Interfaces; use Interfaces;
procedure TestCRC is
   package IIO is new Ada.Text_IO.Modular_IO (Unsigned_32);
   crc : CRC32;
   num : Unsigned_32;
   str : String := "The quick brown fox jumps over the lazy dog";
begin
   Initialize (crc);
   Update (crc, str);
   num := Get_Value (crc);
   IIO.Put (num, Base => 16); New_Line;
end TestCRC;
