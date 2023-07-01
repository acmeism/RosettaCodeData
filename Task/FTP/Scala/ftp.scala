import java.io.{File, FileOutputStream, InputStream}

import org.apache.commons.net.ftp.{FTPClient, FTPFile, FTPReply}

import scala.util.{Failure, Try}

object FTPconn extends App {
  val (server, pass) = ("ftp.ed.ac.uk", "-ftptest@example.com")
  val (dir, filename, ftpClient) = ("/pub/cartonet/", "readme.txt", new FTPClient())

  def canConnect(host: String): Boolean = {
    ftpClient.connect(host)
    val connectionWasEstablished = ftpClient.isConnected
    ftpClient.disconnect()
    connectionWasEstablished
  }

  def downloadFileStream(remote: String): InputStream = {
    val stream: InputStream = ftpClient.retrieveFileStream(remote)
    ftpClient.completePendingCommand()
    stream
  }

  def uploadFile(remote: String, input: InputStream): Boolean = ftpClient.storeFile(remote, input)

  if (Try {
    def cwd(path: String): Boolean = ftpClient.changeWorkingDirectory(path)

    def filesInCurrentDirectory: Seq[String] = listFiles().map(_.getName)

    def listFiles(): List[FTPFile] = ftpClient.listFiles.toList

    def downloadFile(remote: String): Boolean = {
      val os = new FileOutputStream(new File(remote))
      ftpClient.retrieveFile(remote, os)
    }

    def connectWithAuth(host: String,
                        password: String,
                        username: String = "anonymous",
                        port: Int = 21): Try[Boolean] = {
      def connect(): Try[Unit] = Try {
        try {
          ftpClient.connect(host, port)
        } catch {
          case ex: Throwable =>
            println(ex.getMessage)
            Failure
        }
        ftpClient.enterLocalPassiveMode()
        serverReply(ftpClient)

        val replyCode = ftpClient.getReplyCode
        if (!FTPReply.isPositiveCompletion(replyCode))
          println("Failure. Server reply code: " + replyCode)
      }

      for {
        connection <- connect()
        login <- Try {
          ftpClient.login(username, password)
        }
      } yield login
    }

    def serverReply(ftpClient: FTPClient): Unit =
      for (reply <- ftpClient.getReplyStrings) println(reply)

    connectWithAuth(server, pass)

    cwd(dir)
    listFiles().foreach(println)

    downloadFile(filename)
    serverReply(ftpClient)
    ftpClient.logout
  }.isFailure) println(s"Failure.")
}
