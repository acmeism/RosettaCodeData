//You need to use these units
uses
  Classes,
  Dialogs,
  XMLIntf,
  XMLDoc;

//..............................................

//This function creates the XML
function CreateXML(aNames, aRemarks: TStringList): string;
var
  XMLDoc: IXMLDocument;
  Root: IXMLNode;
  i: Integer;
begin
  //Input check
  if (aNames   = nil) or
     (aRemarks = nil) then
  begin
     Result:= '<CharacterRemarks />';
     Exit;
  end;

  //Creating the TXMLDocument instance
  XMLDoc:= TXMLDocument.Create(nil);

  //Activating the document
  XMLDoc.Active:= True;

  //Creating the Root element
  Root:= XMLDoc.AddChild('CharacterRemarks');

  //Creating the inner nodes
  for i:=0 to Min(aNames.Count, aRemarks.Count) - 1 do
  with Root.AddChild('Character') do
  begin
    Attributes['name']:= aNames[i];
    Text:= aRemarks[i];
  end;

  //Outputting the XML as a string
  Result:= XMLDoc.XML.Text;
end;

//..............................................

//Consuming code example (fragment)
var
  Names,
  Remarks: TStringList;
begin
  //Creating the lists objects
  Names:= TStringList.Create;
  Remarks:= TStringList.Create;
  try
    //Filling the list with names
    Names.Add('April');
    Names.Add('Tam O''Shanter');
    Names.Add('Emily');

    //Filling the list with remarks
    Remarks.Add('Bubbly: I''m > Tam and <= Emily');
    Remarks.Add('Burns: "When chapman billies leave the street ..."');
    Remarks.Add('Short & shrift');

    //Constructing and showing the XML
    Showmessage(CreateXML(Names, Remarks));

  finally
    //Freeing the list objects
    Names.Free;
    Remarks.Free;
  end;
end;
