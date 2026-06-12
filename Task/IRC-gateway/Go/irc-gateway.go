package main

import (
    "crypto/tls"
    "fmt"
    "github.com/thoj/go-ircevent"
    "log"
    "os"
)

func main() {
    if len(os.Args) != 9 {
        fmt.Println("To use this gateway, you need to pass 8 command line arguments, namely:")
        fmt.Println("  <server1> <channel1> <nick1> <user1> <server2> <channel2> <nick2> <user2>")
        return
    }
    server1, channel1, nick1, user1 := os.Args[1], os.Args[2], os.Args[3], os.Args[4]
    server2, channel2, nick2, user2 := os.Args[5], os.Args[6], os.Args[7], os.Args[8]

    irc1 := irc.IRC(nick1, user1)
    irc1.VerboseCallbackHandler = true
    irc1.Debug = false
    irc1.UseTLS = true
    irc1.TLSConfig = &tls.Config{InsecureSkipVerify: true}

    irc2 := irc.IRC(nick2, user2)
    irc2.VerboseCallbackHandler = true
    irc2.Debug = false
    irc2.UseTLS = true
    irc2.TLSConfig = &tls.Config{InsecureSkipVerify: true}

    irc1.AddCallback("001", func(e *irc.Event) {
        irc1.Join(channel1)
        msg := fmt.Sprintf("<gateway> Hello %s. Please send your first message to %s.", nick1, nick2)
        irc1.Privmsg(nick1, msg)
        log.Println(msg)
    })

    irc1.AddCallback("366", func(e *irc.Event) {})

    irc1.AddCallback("PRIVMSG", func(e *irc.Event) {
        msg := fmt.Sprintf("<%s> %s", nick1, e.Message)
        irc2.Privmsg(nick2, msg)
        log.Println(msg)
    })

    irc2.AddCallback("001", func(e *irc.Event) {
        irc2.Join(channel2)
        msg := fmt.Sprintf("<gateway> Hello %s. Please wait for your first message from %s.", nick2, nick1)
        irc2.Privmsg(nick2, msg)
        log.Println(msg)
    })

    irc2.AddCallback("366", func(e *irc.Event) {})

    irc2.AddCallback("PRIVMSG", func(e *irc.Event) {
        msg := fmt.Sprintf("<%s> %s", nick2, e.Message)
        irc1.Privmsg(nick1, msg)
        log.Println(msg)
    })

    err1 := irc1.Connect(server1)
    if err1 != nil {
        log.Fatal(err1)
    }

    err2 := irc2.Connect(server2)
    if err2 != nil {
        log.Fatal(err2)
    }

    go irc2.Loop()
    irc1.Loop()
}
