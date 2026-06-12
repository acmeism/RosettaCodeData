/* IRC_gateway.wren */

import "./dynamic" for Tuple

var Connection = Tuple.create("Connection", ["server", "channel", "nick", "user"])

foreign class IRC {
    construct new(number, nick, user) {}
    foreign connect(server)
    foreign verboseCallbackHandler=(arg)
    foreign debug=(arg)
    foreign useTLS=(arg)
    foreign configTLS=(arg)
    foreign addCallback(number, code, msg, channel, nick, otherNick)
}

foreign class Reader {
    construct new() {}
    foreign readLine()
}

var reader = Reader.new()
var Connections = List.filled(2, null)
System.print("To use this gateway, please enter the following:\n")
for (i in 0..1) {
    System.print("Details for connection %(i+1):")
    System.write("  Server   : ")
    var server = reader.readLine()
    System.write("  Channel  : ")
    var channel = reader.readLine()
    System.write("  Nickname : ")
    var nick = reader.readLine()
    System.write("  User     : ")
    var user = reader.readLine()
    Connections[i] = Connection.new(server, channel, nick, user)
    System.print()
}

for (i in 0..1) {
    var c = Connections[i]
    var irc = IRC.new(i, c.nick, c.user)
    irc.verboseCallbackHandler = true
    irc.debug = false
    irc.useTLS = true
    irc.configTLS = true
    var otherNick = (i == 0) ? Connections[1].nick : Connections[0].nick
    var msg
    if (i == 0) {
        msg = "<gateway> Hello %(c.nick). Please send your first message to %(otherNick)."
    } else {
        msg = "<gateway> Hello %(c.nick). Please wait for your first message from %(otherNick)."
    }
    irc.addCallback(i, "001",     msg, c.channel, c.nick, otherNick)
    irc.addCallback(i, "366",     "" , c.channel, c.nick, otherNick)
    irc.addCallback(i, "PRIVMSG", "" , c.channel, c.nick, otherNick)
    irc.connect(c.server)
}
