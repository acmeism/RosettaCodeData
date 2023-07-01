// version 1.2.0

import java.security.KeyStore
import javax.net.ssl.KeyManagerFactory
import javax.net.ssl.SSLContext
import javax.net.ssl.HttpsURLConnection
import java.net.URL
import java.io.FileInputStream
import java.io.InputStreamReader
import java.io.BufferedReader

fun getSSLContext(p12Path: String, password: String): SSLContext {
    val ks = KeyStore.getInstance("pkcs12")
    val fis = FileInputStream(p12Path)
    val pwd = password.toCharArray()
    ks.load(fis, pwd)
    val kmf = KeyManagerFactory.getInstance("PKIX")
    kmf.init(ks, pwd)
    val sc = SSLContext.getInstance("TLS")
    sc.init(kmf.keyManagers, null, null)
    return sc
}

fun main(args: Array<String>) {
    // The .p12 file contains the client certificate and private key
    val sc = getSSLContext("whatever.p12", "password")
    val url = URL("https://somehost.com")
    val con = url.openConnection() as HttpsURLConnection
    con.sslSocketFactory = sc.socketFactory
    val isr = InputStreamReader(con.inputStream)
    val br = BufferedReader(isr)
    while (true) {
        val line = br.readLine()
        if (line == null) break
        println(line)
    }
}
