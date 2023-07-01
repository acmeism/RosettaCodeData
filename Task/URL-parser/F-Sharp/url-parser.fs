open System
open System.Text.RegularExpressions

let writeline n v = if String.IsNullOrEmpty(v) then () else printfn "%-15s %s" n v

let toUri = fun s -> Uri(s.ToString())
let urisFromString = (Regex(@"\S+").Matches) >> Seq.cast >> (Seq.map toUri)

urisFromString """
    foo://example.com:8042/over/there?name=ferret#nose
    urn:example:animal:ferret:nose
    jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true
    ftp://ftp.is.co.za/rfc/rfc1808.txt
    http://www.ietf.org/rfc/rfc2396.txt#header1
    ldap://[2001:db8::7]/c=GB?objectClass?one
    mailto:John.Doe@example.com
    news:comp.infosystems.www.servers.unix
    tel:+1-816-555-1212
    telnet://192.0.2.16:80/
    urn:oasis:names:specification:docbook:dtd:xml:4.1.2
    """
|> Seq.iter (fun u ->
    writeline "\nURI:" (u.ToString())
    writeline "     scheme:" (u.Scheme)
    writeline "     host:" (u.Host)
    writeline "     port:" (if u.Port < 0 then "" else u.Port.ToString())
    writeline "     path:" (u.AbsolutePath)
    writeline "     query:" (if u.Query.Length > 0 then u.Query.Substring(1) else "")
    writeline "     fragment:" (if u.Fragment.Length > 0 then u.Fragment.Substring(1) else "")
    )
