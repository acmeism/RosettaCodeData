{$reference System.Xml.Linq.dll}
{$reference System.Xml.XDocument.dll}
uses System.Xml.Linq;

function CreateXML(characterRemarks: Dictionary<string, string> ): string;
begin
  var remarks := characterRemarks.Select(r -> new XElement('Character', r.Value, new XAttribute('Name', r.Key)));
  var xml := new XElement('CharacterRemarks', remarks);
  Result := xml.ToString;
end;

begin
  var characterRemarks := Dict(
    ('April', 'Bubbly: I''m > Tam and <= Emily' ),
    ( 'Tam O''Shanter', 'Burns: "When chapman billies leave the street ..."' ),
    ( 'Emily', 'Short & shrift' )
  );
  var xml := CreateXML(characterRemarks);
  Writeln(xml);
end.
