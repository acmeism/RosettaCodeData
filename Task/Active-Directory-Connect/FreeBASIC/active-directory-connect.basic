#Include "win\winldap.bi"

Dim ldap As LDAP Ptr
Dim hostname As String
Dim port As Integer
Dim username As String
Dim password As String
Dim result As Integer

hostname = "ldap.example.com"
port = 389    ' Standard port for LDAP. Use 636 for LDAPS.
username = "cn=username,dc=example,dc=com"
password = "password"

' Initialize the LDAP connection
ldap = ldap_init(hostname, port)
If ldap = NULL Then
     Print "Error initializing LDAP connection"
     Sleep
     End 1
End If

' Authenticate with the LDAP server
result = ldap_simple_bind_s(ldap, username, password)
If result <> LDAP_SUCCESS Then
     Print "Error authenticating with LDAP server: "; ldap_err2string(result)
     Sleep
     End 1
End If

' Here you can perform LDAP operations
'...

' We close the connection when finished
ldap_unbind(ldap)
