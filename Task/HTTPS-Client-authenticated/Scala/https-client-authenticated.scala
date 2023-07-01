import java.io.FileInputStream
import java.net.URL
import java.security.KeyStore

import javax.net.ssl.{HttpsURLConnection, KeyManagerFactory, SSLContext}

import scala.io.BufferedSource

object ClientAuthenticated extends App {

  val con: HttpsURLConnection =
    new URL("https://somehost.com").openConnection().asInstanceOf[HttpsURLConnection]

  def getSSLContext(p12Path: String, password: String): SSLContext = {
    val ks = KeyStore.getInstance("pkcs12")
    val pwd = password.toCharArray
    ks.load(new FileInputStream(p12Path), pwd)
    val kmf = KeyManagerFactory.getInstance("PKIX")
    kmf.init(ks, pwd)
    val sc = SSLContext.getInstance("TLS")
    sc.init(kmf.getKeyManagers, null, null)
    sc
  }

  // The .p12 file contains the client certificate and private key
  HttpsURLConnection.setDefaultSSLSocketFactory(getSSLContext("whatever.p12", "password").getSocketFactory)
  new BufferedSource(con.getInputStream).getLines.foreach(println(_))

}
