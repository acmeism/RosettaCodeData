import java.net.{Authenticator, PasswordAuthentication, URL}

import javax.net.ssl.HttpsURLConnection

import scala.io.BufferedSource


object Authenticated extends App {

  val con: HttpsURLConnection =
    new URL("https://somehost.com").openConnection().asInstanceOf[HttpsURLConnection]

  object PasswordAuthenticator extends Authenticator {
    override def getPasswordAuthentication =
      new PasswordAuthentication("username", "password".toCharArray)
  }

  Authenticator.setDefault(PasswordAuthenticator)
  con.setAllowUserInteraction(true)
  con.connect()

  new BufferedSource(con.getInputStream).getLines.foreach(println(_))

}
