using System.Xml;
using System.Xml.Serialization;
[XmlRoot("root")]
public class ExampleXML
{
    [XmlElement("element")]
    public string element = "Some text here";
    static void Main(string[] args)
    {
        var xmlnamespace = new XmlSerializerNamespaces();
        xmlnamespace.Add("", ""); //used to stop default namespaces from printing
        var writer = XmlWriter.Create("output.xml");
        new XmlSerializer(typeof(ExampleXML)).Serialize(writer, new ExampleXML(), xmlnamespace);
    }
    //Output: <?xml version="1.0" encoding="utf-8"?><root><element>Some text here</element></root>
}
