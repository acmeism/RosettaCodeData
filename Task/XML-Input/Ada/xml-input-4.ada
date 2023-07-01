with Ada.Text_IO;
with Sax.Readers;
with Input_Sources.Strings;
with Unicode.CES.Utf8;
with DOM.Readers;
with DOM.Core.Documents;
with DOM.Core.Nodes;
with DOM.Core.Attrs;

procedure Extract_Students is
   Sample_String : String :=
"<Students>" &
   "<Student Name=""April"" Gender=""F"" DateOfBirth=""1989-01-02"" />" &
   "<Student Name=""Bob"" Gender=""M"" DateOfBirth=""1990-03-04"" />" &
   "<Student Name=""Chad"" Gender=""M"" DateOfBirth=""1991-05-06"" />" &
   "<Student Name=""Dave"" Gender=""M"" DateOfBirth=""1992-07-08"">" &
      "<Pet Type=""dog"" Name=""Rover"" />" &
   "</Student>" &
   "<Student DateOfBirth=""1993-09-10"" Gender=""F"" Name=""&#x00C9;mily"" />" &
"</Students>";
   Input : Input_Sources.Strings.String_Input;
   Reader : DOM.Readers.Tree_Reader;
   Document : DOM.Core.Document;
   List : DOM.Core.Node_List;
begin
   Input_Sources.Strings.Open (Sample_String, Unicode.CES.Utf8.Utf8_Encoding, Input);
   DOM.Readers.Parse (Reader, Input);
   Input_Sources.Strings.Close (Input);
   Document := DOM.Readers.Get_Tree (Reader);
   List := DOM.Core.Documents.Get_Elements_By_Tag_Name (Document, "Student");
   for I in 0 .. DOM.Core.Nodes.Length (List) - 1 loop
      Ada.Text_IO.Put_Line
        (DOM.Core.Attrs.Value
           (DOM.Core.Nodes.Get_Named_Item
              (DOM.Core.Nodes.Attributes
                 (DOM.Core.Nodes.Item (List, I)), "Name")
           )
       );
   end loop;
   DOM.Readers.Free (Reader);
end Extract_Students;
