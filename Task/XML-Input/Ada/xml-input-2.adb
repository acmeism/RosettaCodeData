with Sax.Attributes;
with Sax.Readers;
with Unicode.CES;
package My_Reader is
   type Reader is new Sax.Readers.Reader with null record;
   procedure Start_Element
     (Handler       : in out Reader;
      Namespace_URI : Unicode.CES.Byte_Sequence := "";
      Local_Name    : Unicode.CES.Byte_Sequence := "";
      Qname         : Unicode.CES.Byte_Sequence := "";
      Atts          : Sax.Attributes.Attributes'Class);
end My_Reader;
