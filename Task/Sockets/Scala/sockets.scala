import java.net.Socket

object sendSocketData {

  def sendData(host: String, msg: String) {
    val sock = new Socket(host, 256)
    sock.getOutputStream().write(msg.getBytes())
    sock.getOutputStream().flush()
    sock.close()
  }

  sendData("localhost", "hello socket world")
}
