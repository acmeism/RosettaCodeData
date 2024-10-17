PR read "uriParser.a68" PR

PROC test uri parser = ( STRING uri )VOID:
     BEGIN
         URI result := parse uri( uri );
         print( ( uri, ":", newline ) );
         IF NOT ok OF result
         THEN
             # the parse failed #
             print( ( "    ", error OF result, newline ) )
         ELSE
             # parsed OK #
             print(     ( "      scheme: ",      scheme OF result, newline ) );
             IF   userinfo OF result /= "" THEN
                 print( ( "    userinfo: ",    userinfo OF result, newline ) )
             FI;
             IF       host OF result /= "" THEN
                 print( ( "        host: ",        host OF result, newline ) )
             FI;
             IF       port OF result /= "" THEN
                 print( ( "        port: ",        port OF result, newline ) )
             FI;
             IF       path OF result /= "" THEN
                 print( ( "        path: ",        path OF result, newline ) )
             FI;
             IF      query OF result /= "" THEN
                 print( ( "       query: ",       query OF result, newline ) )
             FI;
             IF fragment id OF result /= "" THEN
                 print( ( " fragment id: ", fragment id OF result, newline ) )
             FI
         FI;
         print( ( newline ) )
     END # test uri parser # ;

BEGIN test uri parser( "foo://example.com:8042/over/there?name=ferret#nose"                      )
    ; test uri parser( "urn:example:animal:ferret:nose"                                          )
    ; test uri parser( "jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true" )
    ; test uri parser( "ftp://ftp.is.co.za/rfc/rfc1808.txt"                                      )
    ; test uri parser( "http://www.ietf.org/rfc/rfc2396.txt#header1"                             )
    ; test uri parser( "ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two"               )
    ; test uri parser( "mailto:John.Doe@example.com"                                             )
    ; test uri parser( "news:comp.infosystems.www.servers.unix"                                  )
    ; test uri parser( "tel:+1-816-555-1212"                                                     )
    ; test uri parser( "telnet://192.0.2.16:80/"                                                 )
    ; test uri parser( "urn:oasis:names:specification:docbook:dtd:xml:4.1.2"                     )
    ; test uri parser( "ssh://alice@example.com"                                                 )
    ; test uri parser( "https://bob:pass@example.com/place"                                      )
    ; test uri parser( "http://example.com/?a=1&b=2+2&c=3&c=4&d=%65%6e%63%6F%64%65%64"           )
END
