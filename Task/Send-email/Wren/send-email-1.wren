/* Send_email.wren */

foreign class Authority {
    construct plainAuth(identity, username, password, host) {}
}

class SMTP {
    foreign static sendMail(address, auth, from, to, msg)
}

class Message {
    static check(host, user, pass) {
        if (host == "") Fiber.abort("Bad host")
        if (user == "") Fiber.abort("Bad username")
        if (pass == "") Fiber.abort("Bad password")
    }

    construct new(from, to, cc, subject, content) {
        _from = from
        _to = to
        _cc = cc
        _subject = subject
        _content = content
    }

    toString {
        var to = _to.join(",")
        var cc = _cc.join(",")
        var s1 = "From: " + _from + "\n"
        var s2 = "To: " + to + "\n"
        var s3 = "Cc: " + cc + "\n"
        var s4 = "Subject: " + _subject + "\n\n"
        return s1 + s2 + s3 + s4 + _content
    }

    send(host, port, user, pass) {
        Message.check(host, user, pass)
        SMTP.sendMail(
            "%(host):%(port)",
            Authority.plainAuth("", user, pass, host),
            _from,
            _to,
            toString
        )
    }
}

foreign class Reader {
    construct new() {}

    foreign readString(delim)
}

var host = "smtp.gmail.com"
var port = 587
var user = "some.user@gmail.com"
var pass = "secret"

var bufin = Reader.new()
var NL = 10

System.write("From: ")
var from = bufin.readString(NL).trim()

var to = []
while (true) {
    System.write("To (Blank to finish): ")
    var tmp = bufin.readString(NL).trim()
    if (tmp == "") break
    to.add(tmp)
}

var cc = []
while (true) {
    System.write("Cc (Blank to finish): ")
    var tmp = bufin.readString(NL).trim()
    if (tmp == "") break
    cc.add(tmp)
}

System.write("Subject: ")
var subject = bufin.readString(NL).trim()

var contentLines = []
while (true) {
    System.write("Content line (Blank to finish): ")
    var line = bufin.readString(NL).trim()
    if (line == "") break
    contentLines.add(line)
}
var content = contentLines.join("\r\n")

var m = Message.new(from, to, cc, subject, content)
System.print("\nSending message...")
m.send(host, port, user, pass)
System.print("Message sent.")
