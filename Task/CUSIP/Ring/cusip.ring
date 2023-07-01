# Project : CUSIP

inputstr = list(6)
inputstr[1] = "037833100"
inputstr[2] = "17275R102"
inputstr[3] = "38259P508"
inputstr[4] = "594918104"
inputstr[5] = "68389X106"
inputstr[6] = "68389X105"
for n = 1 to len(inputstr)
     cusip(inputstr[n])
next

func cusip(inputstr)
        if len(inputstr) != 9
            see " length is incorrect, invalid cusip"
            return
        ok
        v = 0
        sum = 0
        for i = 1 to 8
             flag = 0
             x = ascii(inputstr[i])
             if x >= ascii("0") and x <= ascii("9")
                v = x - ascii("0")
                flag = 1
             ok
             if x >= ascii("A") and x <= ascii("Z")
                v = x - 55
                flag = 1
             ok
             if x = ascii("*")
                v= 36
                flag = 1
             ok
             if x = ascii("@")
                v = 37
                flag = 1
             ok
             if x = ascii("#")
                v = 38
                flag = 1
             ok
             if flag = 0
                  see " found a invalid character, invalid cusip" + nl
             ok
             if (i % 2) = 0
                 v = v * 2
             ok
             sum = sum + floor(v / 10) + v % 10
        next
        sum = (10 - (sum % 10)) % 10
        if sum = (ascii(inputstr[9]) - ascii("0"))
           see inputstr + " is valid" + nl
        else
           see inputstr + " is invalid" + nl
        ok
