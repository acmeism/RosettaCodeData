using System;
using System.Xml;
using System.Xml.Schema;
using System.IO;

public class Test
{
	public static void Main()
	{
		// your code goes here
		XmlSchemaSet sc = new XmlSchemaSet();
		sc.Add(null, "http://venus.eas.asu.edu/WSRepository/xml/Courses.xsd");
		XmlReaderSettings settings = new XmlReaderSettings();
		settings.ValidationType = ValidationType.Schema;
		settings.Schemas = sc;
		settings.ValidationEventHandler += new ValidationEventHandler(ValidationCallBack);
		// Create the XmlReader object.
		XmlReader reader = XmlReader.Create("http://venus.eas.asu.edu/WSRepository/xml/Courses.xml", settings);
		// Parse the file.
		while (reader.Read());
		// will call event handler if invalid
		Console.WriteLine("The XML file is valid for the given xsd file");
	}
	
	// Display any validation errors.
	private static void ValidationCallBack(object sender, ValidationEventArgs e) {
		Console.WriteLine("Validation Error: {0}", e.Message);
	}
}
