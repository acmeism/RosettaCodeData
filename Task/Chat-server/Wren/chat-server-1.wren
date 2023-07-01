/* chat_server.wren */

class Clients {
    foreign static max
    foreign static count
    foreign static isActive(vmi)
    foreign static connfd(vmi)
    foreign static uid(vmi)
    foreign static name(vmi)
    foreign static setName(vmi, s)
    foreign static printAddr(vmi)
    foreign static delete(vmi)
}

class Mutex {
    foreign static clientsLock()
    foreign static clientsUnlock()

    foreign static topicLock()
    foreign static topicUnlock()
}

class Chat {
    // send message to all clients but the sender
    static sendMessage(s, uid) {
        Mutex.clientsLock()
        for (i in 0...Clients.max) {
            if (Clients.isActive(i) && Clients.uid(i) != uid) {
                if (write(Clients.connfd(i), s, s.bytes.count) < 0) {
                    System.print("Write to descriptor %(Clients.connfd(i)) failed.")
                    break
                }
            }
        }
        Mutex.clientsUnlock()
    }

    // send message to all clients
    static sendMessageAll(s) {
        Mutex.clientsLock()
        for (i in 0...Clients.max) {
            if (Clients.isActive(i)) {
                if (write(Clients.connfd(i), s, s.bytes.count) < 0) {
                    System.print("Write to descriptor %(Clients.connfd(i)) failed.")
                    break
                }
            }
        }
        Mutex.clientsUnlock()
    }

    // send message to sender
    static sendMessageSelf(s, connfd) {
        if (write(connfd, s, s.bytes.count) < 0) {
            Fiber.abort("Write to descriptor %(connfd) failed.")
        }
    }

    // send message to client
    static sendMessageClient(s, uid) {
        Mutex.clientsLock()
        for (i in 0...Clients.max) {
            if (Clients.isActive(i) && Clients.uid(i) == uid) {
                if (write(Clients.connfd(i), s, s.bytes.count) < 0) {
                    System.print("Write to descriptor %(Clients.connfd(i)) failed.")
                    break
                }
            }
        }
        Mutex.clientsUnlock()
    }

    // send list of active clients
    static sendActiveClients(connfd) {
        Mutex.clientsLock()
        for (i in 0...Clients.max) {
            if (Clients.isActive(i)) {
                var s = "<< [%(Clients.uid(i))] %(Clients.name(i))\r\n"
                sendMessageSelf(s, connfd)
            }
        }
        Mutex.clientsUnlock()
    }

    // handle all communication with the client
    static handleClient(vmi) {
        if (!Clients.isActive(vmi)) {
            Fiber.abort("The client handled by VM[%(vmi)] is inactive.")
        }
        var connfd = Clients.connfd(vmi)
        var uid    = Clients.uid(vmi)
        var name   = Clients.name(vmi)
        System.write("<< accept ")
        Clients.printAddr(vmi)
        System.print(" referenced by %(uid)")
        var buffOut = "<< %(name) has joined\r\n"
        sendMessageAll(buffOut)
        Mutex.topicLock()
        if (topic != "") {
            buffOut = "<< topic: %(topic)\r\n"
            sendMessageSelf(buffOut, connfd)
        }
        Mutex.topicUnlock()
        sendMessageSelf("<< see /help for assistance\r\n", connfd)

        /* receive input from client */
        var buffIn = ""
        while ((buffIn = read(connfd, bufferSize/2 - 1)) && buffIn.bytes.count > 0) {
            buffOut = ""
            buffIn = buffIn.trimEnd("\r\n")

            /* ignore empty buffer */
            if (buffIn == "") continue

            /* special options */
            if (buffIn[0] == "/") {
                var split = buffIn.split(" ")
                var command = split[0]
                if (command == "/quit") {
                    break
                } else if (command == "/ping") {
                    sendMessageSelf("<< pong\r\n", connfd)
                } else if (command == "/topic") {
                    if (split.count > 0) {
                        Mutex.topicLock()
                        topic = split[1..-1].join(" ")
                        Mutex.topicUnlock()
                        buffOut = "<< topic changed to: %(topic)\r\n"
                        sendMessageAll(buffOut)
                    } else {
                        sendMessageSelf("<< message cannot be null\r\n", connfd)
                    }
                } else if (command == "/nick") {
                    if (split.count > 0) {
                        var newName = split[1..-1].join(" ")
                        buffOut = "<< %(name) is now known as %(newName)\r\n"
                        Clients.setName(vmi, newName)
                        name = newName
                        sendMessageAll(buffOut)
                    } else {
                        sendMessageSelf("<< name cannot be null\r\n", connfd)
                    }
                } else if (command == "/msg") {
                    if (split.count > 0) {
                        var toUid = Num.fromString(split[1])
                        if (split.count > 1) {
                            buffOut = "[PM][%(name)] "
                            buffOut = buffOut + split[2..-1].join(" ") + "\r\n"
                            sendMessageClient(buffOut, toUid)
                        } else {
                            sendMessageSelf("<< message cannot be null\r\n", connfd)
                        }
                    } else {
                        sendMessageSelf("<< reference cannot be null\r\n", connfd)
                    }
                } else if (command == "/list") {
                    buffOut = "<< clients %(Clients.count)\r\n"
                    sendMessageSelf(buffOut, connfd)
                    sendActiveClients(connfd)
                } else if (command == "/help") {
                    buffOut = ""
                    buffOut = buffOut + "<< /quit      Quit chatroom\r\n"
                    buffOut = buffOut + "<< /ping      Server test\r\n"
                    buffOut = buffOut + "<< /topic     <message> Set chat topic\r\n"
                    buffOut = buffOut + "<< /nick      <name> Change nickname\r\n"
                    buffOut = buffOut + "<< /msg       <reference> <message> Send private message\r\n"
                    buffOut = buffOut + "<< /list      Show active clients\r\n"
                    buffOut = buffOut + "<< /help      Show help\r\n"
                    sendMessageSelf(buffOut, connfd)
                } else {
                    sendMessageSelf("<< unknown command\r\n", connfd)
                }
            } else {
                /* send message */
                buffOut = "[%(name)] %(buffIn)\r\n"
                sendMessage(buffOut, uid)
            }
         }

         /* close connection */
         buffOut = "<< [%(name)] has left\r\n"
         sendMessageAll(buffOut)
         close(connfd)

         /* delete client from queue and yield thread (from C side) */
         System.write("<< quit ")
         Clients.printAddr(vmi)
         System.print(" referenced by %(uid)")
         Clients.delete(vmi)
     }

     foreign static topic
     foreign static topic=(s)

     foreign static bufferSize
     foreign static write(connfd, buf, count)
     foreign static read(connfd, count)
     foreign static close(connfd)
}
