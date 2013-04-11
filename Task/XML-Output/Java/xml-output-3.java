import java.io.StringWriter;

import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamWriter;

public class XmlCreationStax {

  private static final String[] names = {"April", "Tam O'Shanter", "Emily"};
  private static final String[] remarks = {"Bubbly: I'm > Tam and <= Emily",
    "Burns: \"When chapman billies leave the street ...\"",
      "Short & shrift"};

  public static void main(String[] args) {
    try {
      final StringWriter buffer = new StringWriter();

      final XMLStreamWriter out = XMLOutputFactory.newInstance()
          .createXMLStreamWriter(buffer);

      out.writeStartDocument("UTF-8", "1.0");
      out.writeStartElement("CharacterRemarks");

      for(int i = 0; i < names.length; i++) {
        out.writeStartElement("Character");
        out.writeAttribute("name", names[i]);
        out.writeCharacters(remarks[i]);
        out.writeEndElement();
      }

      out.writeEndElement();
      out.writeEndDocument();

      System.out.println(buffer);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
