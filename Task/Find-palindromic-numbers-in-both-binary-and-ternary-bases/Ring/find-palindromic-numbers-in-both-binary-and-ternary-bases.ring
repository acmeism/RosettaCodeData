# Project: Find palindromic numbers in both binary and ternary bases

max = 6
nr = 0
pal = 0
see "working..." + nl
see "wait for done..." + nl
while true
      binpal = basedigits(nr,2)
      terpal = basedigits(nr,3)
      bool1 = ispalindrome(binpal)
      bool2 = ispalindrome(terpal)
      if bool1 = 1 and bool2 = 1
         pal = pal + 1
         see string(nr) + " " + binpal + "(2) " + terpal + "(3)" + nl
         if pal = max
            exit
         ok
      ok
      nr = nr + 1
end
see "done..." + nl

func basedigits(n,base)
     if n = 0
        return "0"
     ok
     result = ""
     while n > 0
           result = string(n % base) + result
           n = floor(n/base)
     end
     return result

func ispalindrome(astring)
     if astring = "0"
        return 1
     ok
     bString = ""
     for i=len(aString) to 1 step -1
         bString = bString + aString[i]
     next
     if aString = bString
        return 1
     else
        return 0
     ok
