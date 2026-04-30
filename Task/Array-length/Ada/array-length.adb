with Ada.Text_IO;  use Ada.Text_IO;
with System;

procedure Array_Length is

   Fruits : constant array (Positive range <>) of access constant String
      := (new String'("orange"),
          new String'("apple"));

   Memory_Size : constant Integer := Fruits'Size / System.Storage_Unit;

begin
   Put_Line ("Number of elements : " & Fruits'Length'Image);
   Put_Line ("Array memory Size  : " & Memory_Size'Image & " bytes" );
   Put_Line ("                     " & Integer'Image (Memory_Size * System.Storage_Unit / System.Word_Size) & " words" );
end Array_Length;
