str = "abracadabra"
strTemp = "abracadabra"

repSel(str,"a","A",1)
repSel(str,"a","B",2)
repSel(str,"a","C",4)
repSel(str,"a","D",5)
repSel(str,"b","E",1)
repSel(str,"r","F",2)

see str + " -> " + strTemp + nl

func repSel(str,char1,char2,nr)
     num = 0
     for n = 1 to len(str)
         if str[n] = char1
            num += 1
         ok
         if num = nr
            strTemp[n] = char2
            exit
         ok
     next
     return strTemp
