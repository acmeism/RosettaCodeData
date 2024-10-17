using SMTPClient

addbrackets(s) = replace(s, r"^\s*([^\<\>]+)\s*$", s"<\1>")

function wrapRFC5322(from, to, subject, msg)
    timestr = Libc.strftime("%a, %d %b %Y %H:%M:%S %z", time())
    IOBuffer("Date: $timestr\nTo: $to\nFrom: $from\nSubject: $subject\n\n$msg")
end

function sendemail(from, to, subject, messagebody, serverandport;
                   cc=[], user="", password="", isSSL=true, blocking=true)
    opt = SendOptions(blocking=blocking, isSSL=isSSL, username=user, passwd=password)
    send(serverandport, map(s -> addbrackets(s), vcat(to, cc)), addbrackets(from),
         wrapRFC5322(addbrackets(from), addbrackets(to), subject, messagebody), opt)
end

sendemail("to@example.com", "from@example.com", "TEST", "hello there test message text here", "smtps://smtp.gmail.com",
          user="from@example.com", password="example.com")
