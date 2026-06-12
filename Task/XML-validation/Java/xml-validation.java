import static javax.xml.XMLConstants.W3C_XML_SCHEMA_NS_URI;

import java.net.MalformedURLException;
import java.net.URL;

import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import javax.xml.ws.Holder;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class XmlValidation {
	public static void main(String... args) throws MalformedURLException {
		URL schemaLocation = new URL("http://venus.eas.asu.edu/WSRepository/xml/Courses.xsd");
		URL documentLocation = new URL("http://venus.eas.asu.edu/WSRepository/xml/Courses.xml");
		if (validate(schemaLocation, documentLocation)) {
			System.out.println("document is valid");
		} else {
			System.out.println("document is invalid");
		}
	}

	// The least code you need for validation
	public static boolean minimalValidate(URL schemaLocation, URL documentLocation) {
		SchemaFactory factory = SchemaFactory.newInstance(W3C_XML_SCHEMA_NS_URI);
		try {
			Validator validator = factory.newSchema(schemaLocation).newValidator();
			validator.validate(new StreamSource(documentLocation.toString()));
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	// A more complete validator
	public static boolean validate(URL schemaLocation, URL documentLocation) {
		SchemaFactory factory = SchemaFactory.newInstance(W3C_XML_SCHEMA_NS_URI);
		final Holder<Boolean> valid = new Holder<>(true);
		try {
			Validator validator = factory.newSchema(schemaLocation).newValidator();
			// Get some better diagnostics out
			validator.setErrorHandler(new ErrorHandler(){
				@Override
				public void warning(SAXParseException exception) {
					System.out.println("warning: " + exception.getMessage());
				}

				@Override
				public void error(SAXParseException exception) {
					System.out.println("error: " + exception.getMessage());
					valid.value = false;
				}

				@Override
				public void fatalError(SAXParseException exception) throws SAXException {
					System.out.println("fatal error: " + exception.getMessage());
					throw exception;
				}});
			validator.validate(new StreamSource(documentLocation.toString()));
			return valid.value;
		} catch (SAXException e) {
			// Already reported above
			return false;
		} catch (Exception e) {
			// If this is the only thing that throws, it's a gross error
			System.err.println(e);
			return false;
		}
	}
}
