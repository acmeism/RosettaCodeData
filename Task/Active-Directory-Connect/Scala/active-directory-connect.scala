import java.io.IOException

import org.apache.directory.api.ldap.model.exception.LdapException
import org.apache.directory.ldap.client.api.{LdapConnection, LdapNetworkConnection}

object LdapConnectionDemo {
  @throws[LdapException]
  @throws[IOException]
  def main(args: Array[String]): Unit = {
    try {
      val connection: LdapConnection = new LdapNetworkConnection("localhost", 10389)
      try {
        connection.bind()
        connection.unBind()
      } finally if (connection != null) connection.close()
    }
  }
}
