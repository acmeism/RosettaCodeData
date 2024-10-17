program XMLXPath;

{$APPTYPE CONSOLE}

uses ActiveX, MSXML;

const
  XML =
    '<inventory title="OmniCorp Store #45x10^3">' +
    '  <section name="health">' +
    '    <item upc="123456789" stock="12">' +
    '      <name>Invisibility Cream</name>' +
    '      <price>14.50</price>' +
    '      <description>Makes you invisible</description>' +
    '    </item>' +
    '    <item upc="445322344" stock="18">' +
    '      <name>Levitation Salve</name>' +
    '      <price>23.99</price>' +
    '      <description>Levitate yourself for up to 3 hours per application</description>' +
    '    </item>' +
    '  </section>' +
    '  <section name="food">' +
    '    <item upc="485672034" stock="653">' +
    '      <name>Blork and Freen Instameal</name>' +
    '      <price>4.95</price>' +
    '      <description>A tasty meal in a tablet; just add water</description>' +
    '    </item>' +
    '    <item upc="132957764" stock="44">' +
    '      <name>Grob winglets</name>' +
    '      <price>3.56</price>' +
    '      <description>Tender winglets of Grob. Just add water</description>' +
    '    </item>' +
    '  </section>' +
    '</inventory>';

var
  i: Integer;
  s: string;
  lXMLDoc: IXMLDOMDocument2;
  lNodeList: IXMLDOMNodeList;
  lNode: IXMLDOMNode;
  lItemNames: array of string;
begin
  CoInitialize(nil);
  lXMLDoc := CoDOMDocument.Create;
  lXMLDoc.setProperty('SelectionLanguage', 'XPath');
  lXMLDoc.loadXML(XML);

  Writeln('First item node:');
  lNode := lXMLDoc.selectNodes('//item')[0];
  Writeln(lNode.xml);
  Writeln('');

  lNodeList := lXMLDoc.selectNodes('//price');
  for i := 0 to lNodeList.length - 1 do
    Writeln('Price = ' + lNodeList[i].text);
  Writeln('');

  lNodeList := lXMLDoc.selectNodes('//item/name');
  SetLength(lItemNames, lNodeList.length);
  for i := 0 to lNodeList.length - 1 do
    lItemNames[i] := lNodeList[i].text;
  for s in lItemNames do
    Writeln('Item name = ' + s);
end.
