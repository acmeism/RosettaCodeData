import smtp, net

proc sendMail(fromAddr: string; toAddrs, ccAddrs: seq[string];
              subject, message, login, password: string;
              server = "smtp.gmail.com"; port = Port 465; ssl = true) =
  var msg = createMessage(subject, message, toAddrs, ccAddrs)
  var s = connect(server, port, ssl, debug = true)
  s.auth(login, password)
  s.sendmail(fromAddr, toAddrs, $msg)

sendMail(fromAddr = "nim@gmail.com",
         toAddrs  = @["someone@example.com"],
         ccAddrs  = @[],
         subject  = "Hi from Nim",
         message  = "Nim says hi!\nAnd bye again!",
         login    = "nim@gmail.com",
         password = "XXXXXX")
