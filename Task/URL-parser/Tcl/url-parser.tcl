package require uri
package require uri::urn

# a little bit of trickery to format results:
proc pdict {d} {
    array set \t $d
    parray \t
}

proc parse_uri {uri} {
    regexp {^(.*?):(.*)$} $uri -> scheme rest
    if {$scheme in $::uri::schemes} {
        # uri already knows how to split it:
        set parts [uri::split $uri]
    } else {
        # parse as though it's http:
        set parts [uri::SplitHttp $rest]
        dict set parts scheme $scheme
    }
    dict filter $parts value ?* ;# omit empty sections
}

set tests {
    foo://example.com:8042/over/there?name=ferret#nose
    urn:example:animal:ferret:nose
    jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true
    ftp://ftp.is.co.za/rfc/rfc1808.txt
    http://www.ietf.org/rfc/rfc2396.txt#header1
    ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two
    mailto:John.Doe@example.com
    news:comp.infosystems.www.servers.unix
    tel:+1-816-555-1212
    telnet://192.0.2.16:80/
    urn:oasis:names:specification:docbook:dtd:xml:4.1.2
}

foreach uri $tests {
    puts \n$uri
    pdict [parse_uri $uri]
}
