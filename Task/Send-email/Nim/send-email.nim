import smtp

proc sendMail(fromAddr: string; toAddrs, ccAddrs: seq[string];
              subject, message, login, password: string;
              server = "smtp.gmail.com"; port = Port 465; ssl = true) =
  let msg = createMessage(subject, message, toAddrs, ccAddrs)
  let session = newSmtp(useSsl = ssl, debug = true)
  session.connect(server, port)
  session.auth(login, password)
  session.sendMail(fromAddr, toAddrs, $msg)

sendMail(fromAddr = "nim@gmail.com",
         toAddrs  = @["someone@example.com"],
         ccAddrs  = @[],
         subject  = "Hi from Nim",
         message  = "Nim says hi!\nAnd bye again!",
         login    = "nim@gmail.com",
         password = "XXXXXX")
