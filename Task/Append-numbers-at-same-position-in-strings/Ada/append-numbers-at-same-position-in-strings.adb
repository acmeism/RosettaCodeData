with Ada.Text_Io;
with Ada.Strings.Fixed;

procedure Append_Numbers is

   use Ada.Text_Io, Ada.Strings;

   type List_Type is array (Positive range <>) of Natural;

   procedure Put (List : List_Type) is
   begin
      Put ("[");
      for E of List loop
         Put (Natural'Image (E));
      end loop;
      Put ("]");
   end Put;

   List_1 : constant List_Type := ( 1,  2,  3,  4,  5,  6,  7,  8,  9);
   List_2 : constant List_Type := (10, 11, 12, 13, 14, 15, 16, 17, 18);
   List_3 : constant List_Type := (19, 20, 21, 22, 23, 24, 25, 26, 27);
   List   : List_Type (List_1'Range);
begin
   for A in List'Range loop
      List (A) := Natural'Value
        (Fixed.Trim (Natural'Image (List_1 (A)), Left) &
         Fixed.Trim (Natural'Image (List_2 (A)), Left) &
         Fixed.Trim (Natural'Image (List_3 (A)), Left));
   end loop;

   Put (List);  New_Line;
end Append_Numbers;
