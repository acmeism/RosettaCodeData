strUsername = "TestUser"
strQuery = "<LDAP://dc=skycityauckland,dc=sceg,dc=com>;"_
 & "(&(objectclass=*)(samaccountname=" & strUsername & "));distinguishedname;subtree"
objCmd.ActiveConnection = objConn
objCmd.Properties("Page Size")=100
objCmd.CommandText = strQuery
Set objRS = objCmd.Execute
