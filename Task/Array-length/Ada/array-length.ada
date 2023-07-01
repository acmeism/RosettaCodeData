with Ada.Text_IO;  use Ada.Text_IO;

procedure Array_Length is
   Fruits : constant array (Positive range <>) of access constant String
      := (new String'("orange"),
          new String'("apple"));

begin
   for Fruit of Fruits loop
      Ada.Text_IO.Put (Integer'Image (Fruit'Length));
   end loop;

   Ada.Text_IO.Put_Line ("  Array Size : " & Integer'Image (Fruits'Length));
end Array_Length;
