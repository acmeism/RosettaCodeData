import java.io.PrintWriter
import java.net.{ServerSocket, Socket}

import scala.io.Source

object EchoServer extends App {
  private val serverSocket = new ServerSocket(23)
  private var numConnections = 0

  class ClientHandler(clientSocket: Socket) extends Runnable {
    private val (connectionId, closeCmd) = ({numConnections += 1; numConnections}, ":exit")

    override def run(): Unit =
      new PrintWriter(clientSocket.getOutputStream, true) {
        println(s"Connection opened, close with entering '$closeCmd'.")
        Source.fromInputStream(clientSocket.getInputStream).getLines
          .takeWhile(!_.toLowerCase.startsWith(closeCmd))
          .foreach { line =>
            Console.println(s"Received on #$connectionId: $line")
            println(line)  // Echo
          }
        Console.println(s"Gracefully closing connection, #$connectionId")
        clientSocket.close()
    }

    println(s"Handling connection, $connectionId")
  }

  while (true) new Thread(new ClientHandler(serverSocket.accept())).start()
}
