with Ada.Wide_Wide_Text_IO;

with League.Strings;
with XML.SAX.Attributes;
with XML.SAX.Pretty_Writers;

procedure Main is

   function "+"
    (Item : Wide_Wide_String) return League.Strings.Universal_String
       renames League.Strings.To_Universal_String;

   type Remarks is record
      Name   : League.Strings.Universal_String;
      Remark : League.Strings.Universal_String;
   end record;

   type Remarks_Array is array (Positive range <>) of Remarks;

   ------------
   -- Output --
   ------------

   procedure Output (Remarks : Remarks_Array) is
      Writer     : XML.SAX.Pretty_Writers.SAX_Pretty_Writer;
      Attributes : XML.SAX.Attributes.SAX_Attributes;

   begin
      Writer.Set_Offset (2);
      Writer.Start_Document;
      Writer.Start_Element (Qualified_Name => +"CharacterRemarks");

      for J in Remarks'Range loop
         Attributes.Clear;
         Attributes.Set_Value (+"name", Remarks (J).Name);
         Writer.Start_Element
           (Qualified_Name => +"Character", Attributes => Attributes);
         Writer.Characters (Remarks (J).Remark);
         Writer.End_Element (Qualified_Name => +"Character");
      end loop;

      Writer.End_Element (Qualified_Name => +"CharacterRemarks");
      Writer.End_Document;

      Ada.Wide_Wide_Text_IO.Put_Line (Writer.Text.To_Wide_Wide_String);
   end Output;

begin
   Output
    (((+"April",         +"Bubbly: I'm > Tam and <= Emily"),
      (+"Tam O'Shanter", +"Burns: ""When chapman billies leave the street ..."""),
      (+"Emily",         +"Short & shrift")));
end Main;
