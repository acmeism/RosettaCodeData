import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.io.Writer
import java.net.ServerSocket
import java.net.Socket
import java.util.ArrayList
import java.util.Collections

class ChatServer private constructor(private val port: Int) : Runnable {
    private val clients = ArrayList<Client>()

    private val onlineListCSV: String
        @Synchronized get() {
            val sb = StringBuilder()
            sb.append(clients.size).append(" user(s) online: ")
            for (i in clients.indices) {
                sb.append(if (i > 0) ", " else "").append(clients[i].clientName)
            }
            return sb.toString()
        }

    override fun run() {
        try {
            val ss = ServerSocket(port)
            while (true) {
                val s = ss.accept()
                Thread(Client(s)).start()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    @Synchronized
    private fun registerClient(client: Client): Boolean {
        for (otherClient in clients) {
            if (otherClient.clientName!!.equals(client.clientName!!, ignoreCase = true)) {
                return false
            }
        }
        clients.add(client)
        return true
    }

    private fun deRegisterClient(client: Client) {
        var wasRegistered = false
        synchronized(this) {
            wasRegistered = clients.remove(client)
        }
        if (wasRegistered) {
            broadcast(client, "--- " + client.clientName + " left ---")
        }
    }

    private fun broadcast(fromClient: Client, msg: String) {
        // Copy client list (don't want to hold lock while doing IO)
        var clients: List<Client> = Collections.emptyList()
        synchronized(this) {
            clients = ArrayList(this.clients)
        }
        for (client in clients) {
            if (client.equals(fromClient)) {
                continue
            }
            try {
                client.write(msg + "\r\n")
            } catch (e: Exception) {
                e.printStackTrace()
            }

        }
    }

    inner class Client internal constructor(private var socket: Socket?) : Runnable {
        private var output: Writer? = null
        var clientName: String? = null

        override fun run() {
            try {
                socket!!.sendBufferSize = 16384
                socket!!.tcpNoDelay = true
                val input = BufferedReader(InputStreamReader(socket!!.getInputStream()))
                output = OutputStreamWriter(socket!!.getOutputStream())
                write("Please enter your name: ")
                var line: String
                while (true) {
                    line = input.readLine()
                    if (null == line) {
                        break
                    }
                    if (clientName == null) {
                        line = line.trim { it <= ' ' }
                        if (line.isEmpty()) {
                            write("A name is required. Please enter your name: ")
                            continue
                        }
                        clientName = line
                        if (!registerClient(this)) {
                            clientName = null
                            write("Name already registered. Please enter your name: ")
                            continue
                        }
                        write(onlineListCSV + "\r\n")
                        broadcast(this, "+++ $clientName arrived +++")
                        continue
                    }
                    if (line.equals("/quit", ignoreCase = true)) {
                        return
                    }
                    broadcast(this, "$clientName> $line")
                }
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                deRegisterClient(this)
                output = null
                try {
                    socket!!.close()
                } catch (e: Exception) {
                    e.printStackTrace()
                }

                socket = null
            }
        }

        @Throws(IOException::class)
        internal fun write(msg: String) {
            output!!.write(msg)
            output!!.flush()
        }

        internal fun equals(client: Client?): Boolean {
            return (client != null
                && clientName != null
                && client.clientName != null
                && clientName == client.clientName)
        }
    }

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            var port = 4004
            if (args.isNotEmpty()) {
                port = Integer.parseInt(args[0])
            }
            ChatServer(port).run()
        }
    }
}
