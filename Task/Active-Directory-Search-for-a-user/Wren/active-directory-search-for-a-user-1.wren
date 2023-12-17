/* Active_Directory_Search_for_a_user.wren */

var LDAP_SCOPE_SUBTREE = 0x0002

foreign class LDAPMessage {
    construct new() {}

    foreign msgfree()
}

foreign class LDAP {
    construct init(host, port) {}

    foreign simpleBindS(name, password)

    foreign searchS(base, scope, filter, attrs, attrsOnly, res)

    foreign unbind()
}

class C {
    foreign static getInput(maxSize)
}

var name = ""
while (name == "") {
    System.write("Enter name : ")
    name = C.getInput(40)
}

var password = ""
while (password == "") {
    System.write("Enter password : ")
    password = C.getInput(40)
}

var ld = LDAP.init("ldap.somewhere.com", 389)
ld.simpleBindS(name, password)

var result = LDAPMessage.new()
ld.searchS(
    "dc:somewhere,dc=com",
    LDAP_SCOPE_SUBTREE,
    "(&(objectclass=person)(|(cn=joe*)(cn=shmoe*)))", // all persons whose names start with joe or shmoe
    [], 0, result
)

// do stuff with result

result.msgfree()
ld.unbind()
