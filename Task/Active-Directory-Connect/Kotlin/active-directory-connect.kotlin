import org.apache.directory.api.ldap.model.exception.LdapException
import org.apache.directory.ldap.client.api.LdapNetworkConnection
import java.io.IOException
import java.util.logging.Level
import java.util.logging.Logger

class LDAP(map: Map<String, String>) {
    fun run() {
        var connection: LdapNetworkConnection? = null
        try {
            if (info) log.info("LDAP Connection to $hostname on port $port")
            connection = LdapNetworkConnection(hostname, port.toInt())

            try {
                if (info) log.info("LDAP bind")
                connection.bind()
            } catch (e: LdapException) {
                log.severe(e.toString())
            }

            try {
                if (info) log.info("LDAP unbind")
                connection.unBind()
            } catch (e: LdapException) {
                log.severe(e.toString())
            }
        } finally {
            try {
                if (info) log.info("LDAP close connection")
                connection!!.close()
            } catch (e: IOException) {
                log.severe(e.toString())
            }
        }
    }

    private val log = Logger.getLogger(LDAP::class.java.name)
    private val info = log.isLoggable(Level.INFO)
    private val hostname: String by map
    private val port: String by map
}

fun main(args: Array<String>) = LDAP(mapOf("hostname" to "localhost", "port"  to "10389")).run()
