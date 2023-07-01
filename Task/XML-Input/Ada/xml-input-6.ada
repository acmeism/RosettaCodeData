with League.Strings;
with XML.SAX.Attributes;
with XML.SAX.Content_Handlers;

package Handlers is

   type Handler is
     limited new XML.SAX.Content_Handlers.SAX_Content_Handler with null record;

   overriding procedure Start_Element
    (Self           : in out Handler;
     Namespace_URI  : League.Strings.Universal_String;
     Local_Name     : League.Strings.Universal_String;
     Qualified_Name : League.Strings.Universal_String;
     Attributes     : XML.SAX.Attributes.SAX_Attributes;
     Success        : in out Boolean);

   overriding function Error_String
    (Self : Handler) return League.Strings.Universal_String;

end Handlers;
