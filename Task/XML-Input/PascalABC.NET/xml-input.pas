{$reference System.Xml.Linq.dll}
{$reference System.Xml.XDocument.dll}
uses System.Xml.Linq;

begin
  var XMLText := '''
  <Students>
  <Student Name="April" Gender="F" DateOfBirth="1989-01-02" />
  <Student Name="Bob" Gender="M"  DateOfBirth="1990-03-04" />
  <Student Name="Chad" Gender="M"  DateOfBirth="1991-05-06" />
  <Student Name="Dave" Gender="M"  DateOfBirth="1992-07-08">
    <Pet Type="dog" Name="Rover" />
  </Student>
  <Student DateOfBirth="1993-09-10" Gender="F" Name="&#x00C9;mily" />
  </Students>
  ''';
  var xmlDoc := XDocument.Parse(XMLText);
  var q := xmlDoc.Descendants('Student').Select(p -> p.Attribute('Name'));
  q.PrintLines(item -> item.Value);
end.
