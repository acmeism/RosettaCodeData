with Ada.Text_IO;              use Ada.Text_IO;
with System.Storage_Elements;  use System.Storage_Elements;

procedure Test_Address is
   X : Integer := 123;
   Y : Integer;
   for Y'Address use X'Address;
begin
   Put_Line ("At address:" & Integer_Address'Image (To_Integer (Y'Address)));
   Put_Line (Integer'Image (Y));
   X := 456;
   Put_Line (Integer'Image (Y));
end Test_Address;
