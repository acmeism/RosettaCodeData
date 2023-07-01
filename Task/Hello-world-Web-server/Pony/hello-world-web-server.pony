use "net"

actor Main
  new create(env: Env) =>
    try TCPListener(env.root as AmbientAuth,
                Listener,
                "127.0.0.1", "8080")
    else env.err.print("unable to use the network")
    end

// Boilerplate code, create a TCP listener on a socket
class Listener is TCPListenNotify

  new iso create() => None

  fun ref listening(_: TCPListener ref) => None

  fun ref not_listening(listen: TCPListener ref) => listen.close()

  fun ref connected(listen: TCPListener ref): TCPConnectionNotify iso^ =>
    Server


// HTTP server that handles the TCP connections
class val Server is TCPConnectionNotify

  // Empty ctor
  new iso create() => None

  // Impl for when server accepts the client request
  fun accepted(_: TCPConnection ref) => None

  // Impl for when server receives client data
  fun ref received(conn: TCPConnection ref, _: Array[U8] iso, _: USize)
  : Bool
  =>
    // handle request
    conn.write("HTTP/1.1 200 OK\r\n\r\n")
    conn.write("<html><body><p>")
    conn.write("Goodbye, World!")
    conn.write("</p></body></html>")
    conn.dispose()
    false

  // Impl for when client closes the connection
  fun ref closed(conn: TCPConnection ref) => conn.dispose()

  // Impl for when client fails to connect to all possible addresses for the server
  fun ref connect_failed(_: TCPConnection ref) => None
