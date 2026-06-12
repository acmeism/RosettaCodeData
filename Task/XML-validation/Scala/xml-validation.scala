import java.net.URL

import javax.xml.XMLConstants.W3C_XML_SCHEMA_NS_URI
import javax.xml.transform.stream.StreamSource
import javax.xml.validation.SchemaFactory
import javax.xml.ws.Holder
import org.xml.sax.{ErrorHandler, SAXException, SAXParseException}

object XmlValidation extends App {
  val (schemaLocation, documentLocation) = (new URL("http://venus.eas.asu.edu/WSRepository/xml/Courses.xsd")
    , new URL("http://venus.eas.asu.edu/WSRepository/xml/Courses.xml"))

  println(s"Document is ${if (validate(schemaLocation, documentLocation)) "valid" else "invalid"}.")

  // A more complete validator
  def validate(schemaLocation: URL, documentLocation: URL): Boolean = {
    val factory = SchemaFactory.newInstance(W3C_XML_SCHEMA_NS_URI)
    val valid = new Holder[Boolean](true)
    try {
      val validator = factory.newSchema(schemaLocation).newValidator
      // Get some better diagnostics out
      validator.setErrorHandler(new ErrorHandler() {
        override def warning(exception: SAXParseException) = println("warning: " + exception.getMessage)

        override def error(exception: SAXParseException) = {
          println("error: " + exception.getMessage)
          valid.value = false
        }

        override def fatalError(exception: SAXParseException) = {
          println("fatal error: " + exception.getMessage)
          throw exception
        }
      })
      validator.validate(new StreamSource(documentLocation.toString))
      valid.value
    } catch {
      case _: SAXException =>
        // Already reported above
        false
      case e: Exception =>
        // If this is the only thing that throws, it's a gross error
        println(e)
        false
    }
  }
}
