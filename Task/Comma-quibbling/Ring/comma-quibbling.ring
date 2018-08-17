# Project : Comma Quibbling

text = list(4)
text[1] = "{}"
text[2] = "ABC"
text[3] = "ABC,DEF"
text[4] = "ABC,DEF,G,H"
comma(text)

func comma(text)
       listtext = []
       for n = 1 to 4
            listtext = str2list(substr(text[n], ",", nl))
            if n = 2
               see "{" + list2str(listtext) + "}" + nl
               loop
            ok
            if len(listtext) = 1
               see "{}" + nl
               loop
            ok
            str = "{"
            for m = 1 to len(listtext)-1
                if len(listtext) = 2
                   str = str + listtext[m] + " "
                else
                   str = str + listtext[m] + ", "
                ok
            next
            if len(listtext) = 2
               str = left(str, len(str)-1)
            else
               str = left(str, len(str)-2)
            ok
            if len(listtext) = 2
               str = str + " " + listtext[len(listtext)] + "}"
            else
               str = str + " and " + listtext[len(listtext)] + "}"
            ok
            see str + nl
     next
