import java.io.IOException;
import org.apache.directory.api.ldap.model.cursor.CursorException;
import org.apache.directory.api.ldap.model.cursor.EntryCursor;
import org.apache.directory.api.ldap.model.entry.Entry;
import org.apache.directory.api.ldap.model.exception.LdapException;
import org.apache.directory.api.ldap.model.message.SearchScope;
import org.apache.directory.ldap.client.api.LdapConnection;
import org.apache.directory.ldap.client.api.LdapNetworkConnection;

public class LdapSearchDemo {

    public static void main(String[] args) throws IOException, LdapException, CursorException {
        new LdapSearchDemo().demonstrateSearch();
    }

    private void demonstrateSearch() throws IOException, LdapException, CursorException {
        try (LdapConnection conn = new LdapNetworkConnection("localhost", 11389)) {
            conn.bind("uid=admin,ou=system", "********");
            search(conn, "*mil*");
            conn.unBind();
        }
    }

    private void search(LdapConnection connection, String uid) throws LdapException, CursorException {
        String baseDn = "ou=users,o=mojo";
        String filter = "(&(objectClass=person)(&(uid=" + uid + ")))";
        SearchScope scope = SearchScope.SUBTREE;
        String[] attributes = {"dn", "cn", "sn", "uid"};
        int ksearch = 0;

        EntryCursor cursor = connection.search(baseDn, filter, scope, attributes);
        while (cursor.next()) {
            ksearch++;
            Entry entry = cursor.get();
            System.out.printf("Search entry %d = %s%n", ksearch, entry);
        }
    }
}
