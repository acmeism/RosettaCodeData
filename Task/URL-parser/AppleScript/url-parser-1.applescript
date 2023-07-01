use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on parseURLString(URLString)
    set output to {URLString}
    set indent to tab & "• "
    set componentsObject to current application's class "NSURLComponents"'s componentsWithString:(URLString)
    repeat with thisKey in {"scheme", "user", "password", "host", "port", "path", "query", "fragment"}
        set thisValue to (componentsObject's valueForKey:(thisKey))
        if (thisValue is not missing value) then set end of output to indent & thisKey & (" = " & thisValue)
    end repeat

    return join(output, linefeed)
end parseURLString

on join(listOfText, delimiter)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delimiter
    set output to listOfText as text
    set AppleScript's text item delimiters to astid
    return output
end join

-- Test code:
local output, URLString
set output to {}
repeat with URLString in {"foo://example.com:8042/over/there?name=ferret#nose", ¬
    "urn:example:animal:ferret:nose", ¬
    "jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true", ¬
    "ftp://ftp.is.co.za/rfc/rfc1808.txt", ¬
    "http://www.ietf.org/rfc/rfc2396.txt#header1", ¬
    "ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two", ¬
    "mailto:John.Doe@example.com", ¬
    "news:comp.infosystems.www.servers.unix", ¬
    "tel:+1-816-555-1212", ¬
    "telnet://192.0.2.16:80/", ¬
    "urn:oasis:names:specification:docbook:dtd:xml:4.1.2", ¬
    "http://example.com/?a=1&b=2+2&c=3&c=4&d=%65%6e%63%6F%64%65%64"}
    set end of output to parseURLString(URLString's contents)
end repeat

return join(output, linefeed & linefeed)
