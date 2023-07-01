using LDAPClient

conn = LDAPClient.LDAPConnection("ldap://localhost:10389")
LDAPClient.simple_bind(conn, "user", "password")
LDAPClient.unbind(conn)
