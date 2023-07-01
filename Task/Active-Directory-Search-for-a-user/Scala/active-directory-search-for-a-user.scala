import org.apache.directory.api.ldap.model.message.SearchScope
import org.apache.directory.ldap.client.api.{LdapConnection, LdapNetworkConnection}

object LdapSearchDemo extends App {

  class LdapSearch {

    def demonstrateSearch(): Unit = {

      val conn = new LdapNetworkConnection("localhost", 11389)
      try {
        conn.bind("uid=admin,ou=system", "********")
        search(conn, "*mil*")
        conn.unBind()
      } finally if (conn != null) conn.close()

    }

    private def search(connection: LdapConnection, uid: String): Unit = {
      val baseDn = "ou=users,o=mojo"
      val filter = "(&(objectClass=person)(&(uid=" + uid + ")))"
      val scope = SearchScope.SUBTREE
      val attributes = List("dn", "cn", "sn", "uid")
      var ksearch = 0
      val cursor = connection.search(baseDn, filter, scope, attributes: _*)
      while (cursor.next) {
        ksearch += 1
        val entry = cursor.get
        printf("Search entry %d = %s%n", ksearch, entry)
      }
    }
  }

  new LdapSearch().demonstrateSearch()

}
