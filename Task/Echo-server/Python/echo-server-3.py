    #!usr/bin/env python
    import socket
    import threading

    HOST = 'localhost'
    PORT = 12321
    SOCKET_TIMEOUT = 30

    # This function handles reading data sent by a client, echoing it back
    # and closing the connection in case of timeout (30s) or "quit" command
    # This function is meant to be started in a separate thread
    # (one thread per client)
    def handle_echo(client_connection, client_address):
        client_connection.settimeout(SOCKET_TIMEOUT)
        try:
            while True:
                data = client_connection.recv(1024)
                # Close connection if "quit" received from client
                if data == b'quit\r\n' or data == b'quit\n':
                    print('{} disconnected'.format(client_address))
                    client_connection.shutdown(1)
                    client_connection.close()
                    break
                # Echo back to client
                elif data:
                    print('FROM {} : {}'.format(client_address,data))
                    client_connection.send(data)
        # Timeout and close connection after 30s of inactivity
        except socket.timeout:
            print('{} timed out'.format(client_address))
            client_connection.shutdown(1)
            client_connection.close()

    # This function opens a socket and listens on specified port. As soon as a
    # connection is received, it is transfered to another socket so that the main
    # socket is not blocked and can accept new clients.
    def listen(host, port):
        # Create the main socket (IPv4, TCP)
        connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        connection.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        connection.bind((host, port))
        # Listen for clients (max 10 clients in waiting)
        connection.listen(10)
        # Every time a client connects, allow a dedicated socket and a dedicated
        # thread to handle communication with that client without blocking others.
        # Once the new thread has taken over, wait for the next client.
        while True:
            current_connection, client_address = connection.accept()
            print('{} connected'.format(client_address))
            handler_thread = threading.Thread( \
                target = handle_echo, \
                args = (current_connection,client_address) \
            )
            # daemon makes sure all threads are killed if the main server process
            # gets killed
            handler_thread.daemon = True
            handler_thread.start()

    if __name__ == "__main__":
        try:
            listen(HOST, PORT)
        except KeyboardInterrupt:
            print('exiting')
            pass
