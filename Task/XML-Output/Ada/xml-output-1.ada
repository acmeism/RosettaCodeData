with Ada.Strings.Unbounded;
with Ada.Text_IO.Text_Streams;
with DOM.Core.Documents;
with DOM.Core.Elements;
with DOM.Core.Nodes;

procedure Character_Remarks is
   package DC renames DOM.Core;
   package IO renames Ada.Text_IO;
   package US renames Ada.Strings.Unbounded;
   type Remarks is record
      Name : US.Unbounded_String;
      Text : US.Unbounded_String;
   end record;
   type Remark_List is array (Positive range <>) of Remarks;
   My_Remarks : Remark_List :=
      ((US.To_Unbounded_String ("April"),
        US.To_Unbounded_String ("Bubbly: I'm > Tam and <= Emily")),
       (US.To_Unbounded_String ("Tam O'Shanter"),
        US.To_Unbounded_String ("Burns: ""When chapman billies leave the street ...""")),
       (US.To_Unbounded_String ("Emily"),
        US.To_Unbounded_String ("Short & shrift")));
   My_Implementation : DC.DOM_Implementation;
   My_Document       : DC.Document := DC.Create_Document (My_Implementation);
   My_Root_Node      : DC.Element  := DC.Nodes.Append_Child (My_Document,
                                         DC.Documents.Create_Element (My_Document, "CharacterRemarks"));
   My_Element_Node   : DC.Element;
   My_Text_Node      : DC.Text;
begin
   for I in My_Remarks'Range loop
      My_Element_Node := DC.Nodes.Append_Child (My_Root_Node,
                            DC.Documents.Create_Element (My_Document, "Character"));
      DC.Elements.Set_Attribute (My_Element_Node, "Name", US.To_String (My_Remarks (I).Name));
      My_Text_Node    := DC.Nodes.Append_Child (My_Element_Node,
                            DC.Documents.Create_Text_Node (My_Document, US.To_String (My_Remarks (I).Text)));
   end loop;
   DC.Nodes.Write (IO.Text_Streams.Stream (IO.Standard_Output),
                   N => My_Document,
                   Pretty_Print => True);
end Character_Remarks;
