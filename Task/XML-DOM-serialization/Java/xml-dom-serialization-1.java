import java.io.StringWriter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class RDOMSerialization {

  private Document domDoc;

  public RDOMSerialization() {
    return;
  }

  protected void buildDOMDocument() {

    DocumentBuilderFactory factory;
    DocumentBuilder builder;
    DOMImplementation impl;
    Element elmt1;
    Element elmt2;

    try {
      factory = DocumentBuilderFactory.newInstance();
      builder = factory.newDocumentBuilder();
      impl = builder.getDOMImplementation();
      domDoc = impl.createDocument(null, null, null);
      elmt1 = domDoc.createElement("root");
      elmt2 = domDoc.createElement("element");
      elmt2.setTextContent("Some text here");

      domDoc.appendChild(elmt1);
      elmt1.appendChild(elmt2);
    }
    catch (ParserConfigurationException ex) {
      ex.printStackTrace();
    }

    return;
  }

  protected void serializeXML() {

    DOMSource domSrc;
    Transformer txformer;
    StringWriter sw;
    StreamResult sr;

    try {
      domSrc = new DOMSource(domDoc);

      txformer = TransformerFactory.newInstance().newTransformer();
      txformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
      txformer.setOutputProperty(OutputKeys.METHOD, "xml");
      txformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
      txformer.setOutputProperty(OutputKeys.INDENT, "yes");
      txformer.setOutputProperty(OutputKeys.STANDALONE, "yes");
      txformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");

      sw = new StringWriter();
      sr = new StreamResult(sw);

      txformer.transform(domSrc, sr);

      System.out.println(sw.toString());
    }
    catch (TransformerConfigurationException ex) {
      ex.printStackTrace();
    }
    catch (TransformerFactoryConfigurationError ex) {
      ex.printStackTrace();
    }
    catch (TransformerException ex) {
      ex.printStackTrace();
    }

    return;
  }

  public static void serializationDriver(String[] args) {

    RDOMSerialization lcl = new RDOMSerialization();
    lcl.buildDOMDocument();
    lcl.serializeXML();

    return;
  }

  public static void main(String[] args) {
    serializationDriver(args);
    return;
  }
}
