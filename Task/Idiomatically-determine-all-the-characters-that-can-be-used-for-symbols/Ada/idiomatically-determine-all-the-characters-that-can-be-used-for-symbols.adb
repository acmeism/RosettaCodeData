with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Text_IO;

procedure Show_Valid_Identifiers is
   Valid_First_Character : constant Character_Set := To_Set (Ranges => (1 => ('a', 'z'), 2 => ('A', 'Z')));
   Valid_Last_Character : constant Character_Set := Valid_First_Character or To_Set (Ranges => (1 => ('0', '9')));
   Valid_Middle_Character : constant Character_Set := Valid_Last_Character or To_Set ('_');
begin
   Ada.Text_IO.Put_Line ("Valid for the first character: " & String (To_Sequence (Valid_First_Character)));
   Ada.Text_IO.Put_Line ("Valid for any middle character: " & String (To_Sequence (Valid_Middle_Character)));
   Ada.Text_IO.Put_Line ("Valid for the last character: " & String (To_Sequence (Valid_Last_Character)));
end Show_Valid_Identifiers;
