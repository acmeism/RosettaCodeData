let ldapServer = new System.DirectoryServices.Protocols.LdapDirectoryIdentifier("127.0.0.1")
let connect = new System.DirectoryServices.Protocols.LdapConnection(ldapServer)
connect.Bind()
