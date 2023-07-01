load "stdlib.ring"
See "Send email..." + nl
sendemail("smtp://smtp.gmail.com",
          "calmosoft@gmail.com",
          "password",
          "calmosoft@gmail.com",
          "calmosoft@gmail.com",
          "calmosoft@gmail.com",
          "Sending email from Ring",
          "Hello
           How are you?
           Are you fine?
           Thank you!
           Greetings,
           CalmoSoft")
see "Done.." + nl
