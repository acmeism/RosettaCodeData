import net.urllib

const urls = ['jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true',
  'ftp://ftp.is.co.za/rfc/rfc1808.txt',
  'http://www.ietf.org/rfc/rfc2396.txt#header1',
  'ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two',
  'mailto:John.Doe@example.com',
  'news:comp.infosystems.www.servers.unix',
  'tel:+1-816-555-1212',
  'telnet://192.0.2.16:80/',
  'urn:oasis:names:specification:docbook:dtd:xml:4.1.2',
  'foo://example.com:8042/over/there?name=ferret#nose'
  ]

fn main() {
    for url in urls {
        u := urllib.parse(url)?
        println(u)
        print_url(u)
    }
}

fn print_url(u urllib.URL) {
    println("    Scheme: $u.scheme")
    if u.opaque != "" {
        println("    Opaque: $u.opaque")
    }
    if u.str() == '' {
        println("    Username: $u.user.username")
        if u.user.password != '' {
            println("    Password: $u.user.password")
        }
    }
    if u.host != "" {
        if u.port() != '' {
            println("    Host: ${u.hostname()}")
            println("    Port: ${u.port()}")
        } else {
            println("    Host: $u.host")
        }
    }
    if u.path != "" {
        println("    Path: $u.path")
    }
    if u.raw_query != "" {
        println("    RawQuery: $u.raw_query")
        m := u.query().data
        for q in m {
            println("        Key: $q.key Values: $q.value")
        }
    }
    if u.fragment != "" {
        println("    Fragment: $u.fragment")
    }
}
