procedure main(args)
    mail := open("mailto:"||args[1], "m", "Subject : "||args[2],
                 "X-Note: automatically send by Unicon") |
            stop("Cannot send mail to ",args[1])
    every write(mail , !&input)
    close (mail)
end
