for nr = 0 to 25
    see Nth(nr) + Nth(nr + 250) + Nth(nr + 1000) + nl
next

func getSuffix n
     lastTwo = n % 100
     lastOne = n % 10
     if lastTwo > 3 and lastTwo < 21  "th" ok
     if lastOne = 1 return "st" ok
     if lastOne = 2 return "nd" ok
     if lastOne = 3 return "rd" ok
     return "th"

func Nth n
     return  "" + n + "'" +  getSuffix(n) + " "
