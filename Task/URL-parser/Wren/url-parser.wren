var urlParse = Fn.new { |url|
    var parseUrl = "URL      = " + url
    var index
    if ((index = url.indexOf("//")) && index >= 0 && url[0...index].count { |c| c == ":" } == 1) {
        // parse the scheme
        var scheme = url.split("//")
        parseUrl = parseUrl + "\n" + "Scheme   = " + scheme[0][0..-2]
        // parse the domain
        var domain = scheme[1].split("/")
        // check if the domain includes a username, password and port
        if (domain[0].contains("@")) {
            var cred = domain[0].split("@")
            var split = [cred[0], ""]
            if (cred[0].contains(".")) {
                split = cred[0].split(".")
            } else if (cred[0].contains(":")) {
                split = cred[0].split(":")
            }
            var username = split[0]
            var password = split[1]
            parseUrl = parseUrl + "\n" + "Username = " + username
            if (password != "") parseUrl = parseUrl + "\n" + "Password = " + password
            // check if the domain has a port
            if (cred[1].contains(":")) {
                split = cred[1].split(":")
                var host = split[0]
                var port = ":" + split[1]
                parseUrl = parseUrl + "\n" + "Domain   = " + host + "\n" + "Port     = " + port
            } else {
                parseUrl = parseUrl + "\n" + "Domain   = " + cred[1]
            }
        } else if (domain[0].contains(":") && !domain[0].contains("[") && !domain[0].contains("]")) {
            var split = domain[0].split(":")
            var host = split[0]
            var port = ":" + split[1]
            parseUrl = parseUrl + "\n" + "Domain   = " + host + "\n" + "Port     = " + port
        } else if (domain[0].contains("[") && domain[0].contains("]:")) {
            var split = domain[0].split("]")
            var host = split[0] + "]"
            var port = ":" + split[1][1..-1]
            parseUrl = parseUrl + "\n" + "Domain   = " + host + "\n" + "Port     = " + port
        } else {
            parseUrl = parseUrl + "\n" + "Domain   = " + domain[0]
        }
        // parse the path if it exists
        if (domain.count > 1) {
            var path = "/"
            for (i in 1...domain.count) {
                if (i < domain.count - 1) {
                    path = path + domain[i] + "/"
                } else if (domain[i].contains("?")) {
                    var split = domain[i].split("?")
                    path = path + split[0]
                    if (domain[i].contains("#")) {
                        var split2 = split[1].split("#")
                        var query = split2[0]
                        var fragment = split2[1]
                        path = path + "\n" + "Query    = " + query + "\n" + "Fragment = " + fragment
                    } else {
                        var query = split[1]
                        path = path + "\n" + "Query    = " + query
                    }
                } else if (domain[i].contains("#")) {
                    var split = domain[i].split("#")
                    var fragment = split[1]
                    path = path + split[0] + "\n" + "Fragment = " + fragment
                } else {
                    path = path + domain[i]
                }
            }
            parseUrl = parseUrl + "\n" + "Path     = " + path
        }
    } else if (url.contains(":")) {
        var index = url.indexOf(":")
        var scheme = url[0...index]
        parseUrl = parseUrl + "\n" + "Scheme   = " + scheme + "\n"
        var path = url[index+1..-1]
        if (!path.contains("?")) {
            parseUrl = parseUrl + "Path     = " + path
        } else {
            var split = path.split("?")
            var query = split[1]
            parseUrl = parseUrl + "Path     = " + split[0] + "\n"
            if (!query.contains("#")) {
                parseUrl = parseUrl + "Query    = " + query
            } else {
                split = query.split("#")
                var fragment = split[1]
                parseUrl = parseUrl + "Query    = " + split[0] + "Fragment = " + fragment
            }
        }
    } else {
        parseUrl = parseUrl + "\n" + "Invalid!!!"
    }
    System.print(parseUrl)
    System.print()
}

var urls = [
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
    "http://example.com/?a=1&b=2+2&c=3&c=4&d=\%65\%6e\%63\%6F\%64\%65\%64"
]
for (url in urls) urlParse.call(url)
