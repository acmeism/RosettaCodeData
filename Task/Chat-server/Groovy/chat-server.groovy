class ChatServer implements Runnable {
    private int port = 0
    private List<Client> clientList = new ArrayList<>()

    ChatServer(int port) {
        this.port = port
    }

    @SuppressWarnings("GroovyInfiniteLoopStatement")
    @Override
    void run() {
        try {
            ServerSocket serverSocket = new ServerSocket(port)
            while (true) {
                Socket socket = serverSocket.accept()
                new Thread(new Client(socket)).start()
            }
        } catch (Exception e) {
            e.printStackTrace()
        }
    }

    private synchronized boolean registerClient(Client client) {
        for (Client other : clientList) {
            if (other.clientName.equalsIgnoreCase(client.clientName)) {
                return false
            }
        }
        clientList.add(client)
        return true
    }

    private void deRegisterClient(Client client) {
        boolean wasRegistered
        synchronized (this) {
            wasRegistered = clientList.remove(client)
        }
        if (wasRegistered) {
            broadcast(client, "--- " + client.clientName + " left ---")
        }
    }

    private synchronized String getOnlineListCSV() {
        StringBuilder sb = new StringBuilder()
        sb.append(clientList.size()).append(" user(s) online: ")
        def it = clientList.iterator()
        if (it.hasNext()) {
            sb.append(it.next().clientName)
        }
        while (it.hasNext()) {
            sb.append(", ")
            sb.append(it.next().clientName)
        }
        return sb.toString()
    }

    private void broadcast(Client fromClient, String msg) {
        // Copy client list (don't want to hold lock while doing IO)
        List<Client> clients
        synchronized (this) {
            clients = new ArrayList<>(this.clientList)
        }
        for (Client client : clients) {
            if (client == fromClient) {
                continue
            }
            try {
                client.write(msg + "\r\n")
            } catch (Exception ignored) {
                // empty
            }
        }
    }

    class Client implements Runnable {
        private Socket socket = null
        private Writer output = null
        private String clientName = null

        Client(Socket socket) {
            this.socket = socket
        }

        @Override
        void run() {
            try {
                socket.setSendBufferSize(16384)
                socket.setTcpNoDelay(true)
                BufferedReader input = new BufferedReader(new InputStreamReader(socket.getInputStream()))
                output = new OutputStreamWriter(socket.getOutputStream())
                write("Please enter your name: ")
                String line
                while (null != (line = input.readLine())) {
                    if (null == clientName) {
                        line = line.trim()
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
                        write(getOnlineListCSV() + "\r\n")
                        broadcast(this, "+++ " + clientName + " arrived +++")
                        continue
                    }
                    if (line.equalsIgnoreCase("/quit")) {
                        return
                    }
                    broadcast(this, clientName + "> " + line)
                }
            } catch (Exception ignored) {
                // empty
            } finally {
                deRegisterClient(this)
                output = null
                try {
                    socket.close()
                } catch (Exception ignored) {
                    // empty
                }
                socket = null
            }
        }

        void write(String msg) {
            output.write(msg)
            output.flush()
        }

        @Override
        boolean equals(client) {
            return (null != client) && (client instanceof Client) && (null != clientName) && clientName == client.clientName
        }

        @Override
        int hashCode() {
            int result
            result = (socket != null ? socket.hashCode() : 0)
            result = 31 * result + (output != null ? output.hashCode() : 0)
            result = 31 * result + (clientName != null ? clientName.hashCode() : 0)
            return result
        }
    }

    static void main(String[] args) {
        int port = 4004
        if (args.length > 0) {
            port = Integer.parseInt(args[0])
        }
        new ChatServer(port).run()
    }
}
