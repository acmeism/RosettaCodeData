// version 1.2.0

import java.net.Authenticator
import java.net.PasswordAuthentication
import javax.net.ssl.HttpsURLConnection
import java.net.URL
import java.io.InputStreamReader
import java.io.BufferedReader

object PasswordAuthenticator : Authenticator() {
    override fun getPasswordAuthentication() =
        PasswordAuthentication ("username", "password".toCharArray())
}

fun main(args: Array<String>) {
    val url = URL("https://somehost.com")
    val con = url.openConnection() as HttpsURLConnection
    Authenticator.setDefault(PasswordAuthenticator)
    con.allowUserInteraction = true
    con.connect()
    val isr = InputStreamReader(con.inputStream)
    val br = BufferedReader(isr)
    while (true) {
        val line = br.readLine()
        if (line == null) break
        println(line)
    }
}
