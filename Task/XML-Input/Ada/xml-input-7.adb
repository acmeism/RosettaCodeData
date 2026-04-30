with Ada.Wide_Wide_Text_IO;

package body Handlers is

   use type League.Strings.Universal_String;

   function "+"
    (Item : Wide_Wide_String) return League.Strings.Universal_String
       renames League.Strings.To_Universal_String;

   ------------------
   -- Error_String --
   ------------------

   overriding function Error_String
    (Self : Handler) return League.Strings.Universal_String is
   begin
      return League.Strings.Empty_Universal_String;
   end Error_String;

   -------------------
   -- Start_Element --
   -------------------

   overriding procedure Start_Element
    (Self           : in out Handler;
     Namespace_URI  : League.Strings.Universal_String;
     Local_Name     : League.Strings.Universal_String;
     Qualified_Name : League.Strings.Universal_String;
     Attributes     : XML.SAX.Attributes.SAX_Attributes;
     Success        : in out Boolean) is
   begin
      if Qualified_Name = +"Student" then
         Ada.Wide_Wide_Text_IO.Put_Line
          (Attributes.Value (+"Name").To_Wide_Wide_String);
      end if;
   end Start_Element;

end Handlers;
