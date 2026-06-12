// Author: Gal Zsolt 2023-02-08
see "works..." + nl + nl
aListSend = []
aListMore = []

for s = 0 to 9
    for e1 = 0 to 9
        for n = 0 to 9
            for d = 0 to 9
                bool = s!=e1 and s!=n and s!=d and e1!=n and e1!=d and n!=d
                if bool
                   sendmore = s*1000+e1*100+n*10+d
                   add(aListSend,sendmore)
                   add(aListMore,sendmore)
                ok
            next
        next
    next
next

for ind1 = len(aListSend) to 1 step -1
    for ind2 = 1 to len(aListMore)
        strSend = string(aListSend[ind1])
        strMore = string(aListMore[ind2])
        m = substr(strMore,1,1)
        o = substr(strMore,2,1)
        r = substr(strMore,3,1)
        e2 = substr(strMore,4,1)
        bool1 = substr(strSend,m)
        bool2 = substr(strSend,o)
        bool3 = substr(strSend,r)
        if substr(strSend,2,1) = substr(strMore,4,1)
            bool4 = 0
        else
            bool4 = 1
        ok
        boolSendMore = bool1 + bool2 + bool3 + bool4
        if boolSendMore < 1
           if substr(strSend,2,1) = substr(strMore,4,1)
              for y = 0 to 9
                  strMoney1 = substr(strMore,1,1) + substr(strMore,2,1) + substr(strSend,3,1)
                  strMoney2 = substr(strMore,4,1) + string(y)
                  strMoney = strMoney1 + strMoney2
                  numMoney = number(strMoney)
                  numSend = number(strSend)
                  numMore = number(strMore)
                  y1 = substr(strMoney,5,1)
                  ySend = substr(strSend,y1)
                  yMore = substr(strMore,y1)
                  yCheck = ySend + yMore
                  r = substr(strMore,3,1)
                  rCheck = substr(strSend,r)
                  if (numSend + numMore = numMoney) and yCheck < 1 and rCheck < 1
                      see "SEND = "+strSend+" MORE = "+strMore+" MONEY = "+strMoney+nl+nl
                      exit 3
                  ok
             next
           ok
        ok
    next
next
see "done..." + nl
