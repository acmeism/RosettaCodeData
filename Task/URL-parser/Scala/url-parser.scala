import java.net.URI

object WebAddressParser extends App {

  parseAddress("foo://example.com:8042/over/there?name=ferret#nose")
  parseAddress("ftp://ftp.is.co.za/rfc/rfc1808.txt")
  parseAddress("http://example.com/?a=1&b=2+2&c=3&c=4&d=%65%6e%63%6F%64%65%64")
  parseAddress("http://www.ietf.org/rfc/rfc2396.txt#header1")
  parseAddress("https://bob:pass@example.com/place")
  parseAddress("jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true")
  parseAddress("ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two")
  parseAddress("ldap://[2001:db8::7]/c=GB?objectClass?one")
  parseAddress("mailto:John.Doe@example.com")
  parseAddress("news:comp.infosystems.www.servers.unix")
  parseAddress("ssh://alice@example.com")
  parseAddress("tel:+1-816-555-1212")
  parseAddress("telnet://192.0.2.16:80/")
  parseAddress("urn:example:animal:ferret:nose")
  parseAddress("urn:oasis:names:specification:docbook:dtd:xml:4.1.2")
  parseAddress("This is not a URI!")

  private def parseAddress(a: String): Unit = {
    print(f"Parsing $a%-72s")
    try {
      val u = new URI(a)
      print("\u2714\tscheme = " + u.getScheme)
      print("\tdomain = " + u.getHost)
      print("\tport = " + (if (-1 == u.getPort) "default" else u.getPort))
      print("\tpath = " + (if (u.getPath == null) u.getSchemeSpecificPart else u.getPath))
      print("\tquery = " + u.getQuery)
      println("\tfragment = " + u.getFragment)
    } catch { case ex: Throwable => println('\u2718') }
  }
}
