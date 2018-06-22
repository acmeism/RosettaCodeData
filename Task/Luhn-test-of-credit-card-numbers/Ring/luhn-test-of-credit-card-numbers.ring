decimals(0)

test = ["49927398716", "49927398717", "1234567812345678", "1234567812345670"]
for n = 1 to len(test)
      see test[n] + " -> " + cardtest(test[n]) + nl
next

func cardtest(numstr)
        revstring = revstr(numstr)
        s1 = revodd(revstring)
        s2 = reveven(revstring)
        s3 =right(string(s1+s2), 1)
        if s3 = "0"
           return "Valid"
        else
           return "Invalid"
        ok

func revstr(str)
      strnew = ""
      for nr = len(str) to 1 step -1
           strnew = strnew + str[nr]
      next
      return strnew

func revodd(str)
        strnew = ""
        for nr = 1 to len(str) step 2
             strnew = strnew + str[nr]
        next
        sumodd = 0
        for p = 1 to len(strnew)
              sumodd = sumodd + number(strnew[p])
        next
        return sumodd

func reveven(str)
        strnew = ""
        for nr = 2 to len(str) step 2
             strnew = strnew + str[nr]
        next
        lsteven = []
        for p = 1 to len(strnew)
             add(lsteven, string(2*number(strnew[p])))
        next
        arreven = list(len(lsteven))
        for q = 1 to len(lsteven)
              sum = 0
              for w = 1 to len(lsteven[q])
                    sum = sum + lsteven[q][w]
              next
              arreven[q] = sum
        next
        sumarr = 0
        for x = 1 to len(arreven)
             sumarr = sumarr + arreven[x]
        next
        return sumarr
