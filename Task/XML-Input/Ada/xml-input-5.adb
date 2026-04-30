with League.Application;
with XML.SAX.Input_Sources.Streams.Files;
with XML.SAX.Simple_Readers;

with Handlers;

procedure Main is
   Handler : aliased Handlers.Handler;
   Input   : aliased XML.SAX.Input_Sources.Streams.Files.File_Input_Source;
   Reader  : aliased XML.SAX.Simple_Readers.SAX_Simple_Reader;

begin
   Input.Open_By_File_Name (League.Application.Arguments.Element (1));
   Reader.Set_Content_Handler (Handler'Unchecked_Access);
   Reader.Parse (Input'Unchecked_Access);
end Main;
