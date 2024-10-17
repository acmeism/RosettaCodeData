//You need to use these units
uses
  SysUtils,
  Dialogs,
  XMLIntf,
  XMLDoc;

//..............................................

//This function process the XML
function GetStudents(aXMLInput: string): string;
var
  XMLDoc: IXMLDocument;
  i: Integer;
begin
  //Creating the TXMLDocument instance
  XMLDoc:= TXMLDocument.Create(nil);

  //Loading8 the XML string
  XMLDoc.LoadFromXML(aXMLInput);

  //Parsing the xml document
  for i:=0 to XMLDoc.DocumentElement.ChildNodes.Count - 1 do
    Result:= Result + XMLDoc.DocumentElement.ChildNodes.Get(i).GetAttributeNS('Name', '') + #13#10;

  //Removing the trailing #13#10 characters
  Result:= Trim(Result);
end;

//..............................................

//Consuming code example (fragment)
var
  XMLInput: string;
begin
  XMLInput:= '<Students>' +
                '<Student Name="April" Gender="F" DateOfBirth="1989-01-02" />' +
                '<Student Name="Bob" Gender="M"  DateOfBirth="1990-03-04" />' +
                '<Student Name="Chad" Gender="M"  DateOfBirth="1991-05-06" />' +
                '<Student Name="Dave" Gender="M"  DateOfBirth="1992-07-08">' +
                  '<Pet Type="dog" Name="Rover" />' +
                '</Student>' +
                '<Student DateOfBirth="1993-09-10" Gender="F" Name="&#x00C9;mily" />'+
              '</Students>';
  Showmessage(GetStudents(XMLInput));
end;
