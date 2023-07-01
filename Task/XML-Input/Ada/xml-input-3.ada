with Ada.Text_IO;
package body My_Reader is
   procedure Start_Element
     (Handler       : in out Reader;
      Namespace_URI : Unicode.CES.Byte_Sequence := "";
      Local_Name    : Unicode.CES.Byte_Sequence := "";
      Qname         : Unicode.CES.Byte_Sequence := "";
      Atts          : Sax.Attributes.Attributes'Class) is
   begin
      if Local_Name = "Student" then
         Ada.Text_IO.Put_Line (Sax.Attributes.Get_Value (Atts, "Name"));
      end if;
   end Start_Element;
end My_Reader;
