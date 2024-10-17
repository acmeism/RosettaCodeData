// version 1.1.2

import java.net.URL
import java.net.MalformedURLException

fun parseUrl(url: String) {
    var u: URL
    var scheme: String
    try {
        u = URL(url)
        scheme = u.protocol
    }
    catch (ex: MalformedURLException) {
        val index = url.indexOf(':')
        scheme = url.take(index)
        u = URL("http" + url.drop(index))
    }
    println("Parsing $url")
    println("  scheme   =  $scheme")

    with(u) {
        if (userInfo != null) println("  userinfo =  $userInfo")
        if (!host.isEmpty())  println("  domain   =  $host")
        if (port != -1)       println("  port     =  $port")
        if (!path.isEmpty())  println("  path     =  $path")
        if (query != null)    println("  query    =  $query")
        if (ref != null)      println("  fragment =  $ref")
    }
    println()
}

fun main(args: Array<String>){
    val urls = arrayOf(
        "foo://example.com:8042/over/there?name=ferret#nose",
        "urn:example:animal:ferret:nose",
        "jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true",
        "ftp://ftp.is.co.za/rfc/rfc1808.txt",
        "http://www.ietf.org/rfc/rfc2396.txt#header1",
        "ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two",
        "mailto:John.Doe@example.com",
        "news:comp.infosystems.www.servers.unix",
        "tel:+1-816-555-1212",
        "telnet://192.0.2.16:80/",
        "urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
        "ssh://alice@example.com",
        "https://bob:pass@example.com/place",
        "http://example.com/?a=1&b=2+2&c=3&c=4&d=%65%6e%63%6F%64%65%64"
    )
    for (url in urls) parseUrl(url)
}
