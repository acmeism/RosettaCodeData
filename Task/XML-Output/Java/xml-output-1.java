import java.io.StringWriter;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class XmlCreation {

  private static final String[] names = {"April", "Tam O'Shanter", "Emily"};
  private static final String[] remarks = {"Bubbly: I'm > Tam and <= Emily",
    "Burns: \"When chapman billies leave the street ...\"",
      "Short & shrift"};

  public static void main(String[] args) {
    try {
      // Create a new XML document
      final Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();

      // Append the root element
      final Element root = doc.createElement("CharacterRemarks");
      doc.appendChild(root);

      // Read input data and create a new <Character> element for each name.
      for(int i = 0; i < names.length; i++) {
        final Element character = doc.createElement("Character");
        root.appendChild(character);
        character.setAttribute("name", names[i]);
        character.appendChild(doc.createTextNode(remarks[i]));
      }

      // Serializing XML in Java is unnecessary complicated
      // Create a Source from the document.
      final Source source = new DOMSource(doc);

      // This StringWriter acts as a buffer
      final StringWriter buffer = new StringWriter();

      // Create a Result as a transformer target.
      final Result result = new StreamResult(buffer);

      // The Transformer is used to copy the Source to the Result object.
      final Transformer transformer = TransformerFactory.newInstance().newTransformer();
      transformer.setOutputProperty("indent", "yes");
      transformer.transform(source, result);

      // Now the buffer is filled with the serialized XML and we can print it
      // to the console.
      System.out.println(buffer.toString());
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

}
