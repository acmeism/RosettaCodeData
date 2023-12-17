/* Active_Directory_Connect.wren */

foreign class LDAP {
    construct init(host, port) {}

    foreign simpleBindS(name, password)

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

// do something here

ld.unbind()
