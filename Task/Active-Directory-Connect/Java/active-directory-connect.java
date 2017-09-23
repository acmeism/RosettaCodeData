import java.io.IOException;
import org.apache.directory.api.ldap.model.exception.LdapException;
import org.apache.directory.ldap.client.api.LdapConnection;
import org.apache.directory.ldap.client.api.LdapNetworkConnection;

public class LdapConnectionDemo {

    public static void main(String[] args) throws LdapException, IOException {
        try (LdapConnection connection = new LdapNetworkConnection("localhost", 10389)) {
            connection.bind();
            connection.unBind();
        }
    }
}
