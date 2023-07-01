import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class MailTo {
    private final To to;
    private List<Field> fields;

    public MailTo(String string) {
        if (string == null)
            throw new NullPointerException();
        if (string.isBlank() || !string.toLowerCase().startsWith("mailto:"))
            throw new IllegalArgumentException("Requires 'mailto' scheme");
        string = string.substring(string.indexOf(':') + 1);
        /* we can use the 'URLDecoder' class to decode any entities */
        string = URLDecoder.decode(string, StandardCharsets.UTF_8);
        /* the address and fields are separated by a '?' */
        int indexOf = string.indexOf('?');
        String[] address;
        if (indexOf == -1)
            address = string.split("@");
        else {
            address = string.substring(0, indexOf).split("@");
            string = string.substring(indexOf + 1);
            /* each field is separated by a '&' */
            String[] fields = string.split("&");
            String[] field;
            this.fields = new ArrayList<>(fields.length);
            for (String value : fields) {
                field = value.split("=");
                this.fields.add(new Field(field[0], field[1]));
            }
        }
        to = new To(address[0], address[1]);
    }

    record To(String user, String host) { }
    record Field(String name, String value) { }
}
