using LDAPClient

function searchLDAPusers(searchstring, uname, pword, host=["example", "com"])
    conn = LDAPClient.LDAPConnection("ldap://ldap.server.net")
    LDAPClient.simple_bind(conn, uname, pword)

    search_string = "CN=Users,DC=$(host[1]),DC=$(host[2])"
    scope = LDAPClient.LDAP_SCOPE_ONELEVEL
    chain = LDAPClient.search(conn, search_string, scope, filter="(&(objectClass=person)(&(uid=$(searchstring))))")

    for entry in LDAPClient.each_entry(chain)
        println("Search for $searchstring found user $(entry["name"]) with attributes:")
        for attr in LDAPClient.each_attribute(entry)
            println("        ", attr)
        end
    end

    LDAPClient.unbind(conn)
end

searchLDAPusers("Mario", "my-username", "my-password")
