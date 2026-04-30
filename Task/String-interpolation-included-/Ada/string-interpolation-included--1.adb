with Ada.Strings.Fixed, Ada.Text_IO;
use  Ada.Strings, Ada.Text_IO;
procedure String_Replace is
   Original : constant String := "Mary had a @__@ lamb.";
   Tbr : constant String := "@__@";
   New_Str : constant String := "little";
   Index : Natural := Fixed.Index (Original, Tbr);
begin
   Put_Line (Fixed.Replace_Slice (
     Original, Index, Index + Tbr'Length - 1, New_Str));
end String_Replace;
