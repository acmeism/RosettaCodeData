# Project : Validate International Securities Identification Number

decimals(0)

test = ["US0378331005",
           "US0373831005",
           "U50378331005",
           "US03378331005",
           "AU0000XVGZA3",
           "AU0000VXGZA3",
           "FR0000988040"]

for n = 1 to len(test)
      testold = test[n]
      ascii1 = ascii(left(test[n],1))
      ascii2 = ascii(substr(test[n],2,1))
      if len(test[n]) != 12 or (ascii1 < 65 or ascii1 > 90) or (ascii2 < 65 or ascii2 > 90)
         see test[n] + " -> Invalid" + nl
         loop
      ok
      for m = 1 to len(test[n])
           if ascii(test[n][m]) > 64 and ascii(test[n][m]) < 91
              asc = ascii(test[n][m]) - 55
              test[n] = left(test[n],m-1) + string(asc) + right(test[n],len(test[n])-m)
           ok
      next
      see testold + " -> " + cardtest(test[n]) + nl
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
