{$reference System.Xml.Serialization.dll}
{$reference System.Xml.dll}
uses System.Xml;
uses System.Xml.Serialization;

type
  [XmlRoot('root')]
  ExampleXML = class
  public
    [XmlElementAttribute('element')]
    element := 'My text';
  end;

begin
  var xmlnamespace := new XmlSerializerNamespaces();
  xmlnamespace.Add('', '');
  var writer := XmlWriter.Create('output.xml');
  (new XmlSerializer(typeof(ExampleXML))).Serialize(writer, new ExampleXML(), xmlnamespace);
end.
