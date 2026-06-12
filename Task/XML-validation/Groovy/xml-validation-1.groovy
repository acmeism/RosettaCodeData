import static javax.xml.XMLConstants.W3C_XML_SCHEMA_NS_URI
import javax.xml.transform.stream.StreamSource
import javax.xml.validation.SchemaFactory
import org.xml.sax.SAXParseException

def factory = SchemaFactory.newInstance(W3C_XML_SCHEMA_NS_URI)
def validate = { schemaURL, docURL ->
    try {
        factory.newSchema(schemaURL.toURL()).newValidator().validate(new StreamSource(docURL))
        true
    } catch (SAXParseException e) {
        false
    }
}
