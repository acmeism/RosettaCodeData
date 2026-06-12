import org.xml.sax.*;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.SAXException;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.ParserConfigurationException;

import java.util.regex.Pattern;
import java.util.regex.Matcher;

class MyHandler extends DefaultHandler {
    private static final String TITLE = "title";
    private static final String TEXT = "text";

    private String lastTag = "";
    private String title = "";

    @Override
    public void characters(char[] ch, int start, int length) throws SAXException {
        String regex = ".*==French==.*";
        Pattern pat = Pattern.compile(regex, Pattern.DOTALL);

        switch (lastTag) {
            case TITLE:
                title = new String(ch, start, length);
                break;
            case TEXT:
                String text = new String(ch, start, length);
                Matcher mat = pat.matcher(text);
                if (mat.matches()) {
                    System.out.println(title);
                }
                break;
        }
    }

    @Override
    public void startElement(String uri, String localName, String qName, Attributes attrs) throws SAXException {
        lastTag = qName;
    }

    @Override
    public void endElement(String uri, String localName, String qName) throws SAXException {
        lastTag = "";
    }
}

public class WiktoWords {
    public static void main(java.lang.String[] args) {
        try {
            SAXParserFactory spFactory = SAXParserFactory.newInstance();
            SAXParser saxParser = spFactory.newSAXParser();
            MyHandler handler = new MyHandler();
            saxParser.parse(new InputSource(System.in), handler);
        } catch(Exception e) {
            System.exit(1);
        }
    }
}
