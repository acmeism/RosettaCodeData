decimals(5)

numDec = 23.34375
convDecToBin(numDec)

numDig = 1011.11101
convBinToDec(numDig)

func convDecToBin(numd)
     see "" + numd + " => "
     num = numd - floor(numd)

     a = floor(numd)
     n = 0
     while pow(2,n+1) < a
           n = n + 1
     end

     for i = n to 0 step -1
         x = pow(2,i)
         if a >= x
            see 1
             a = a - x
         else
            see 0
         ok
     next

     see "."

     numbin = ""

     for n = 1 to 5
         bin = 1/(pow(2,n))
         if num >= bin
            numbin = numbin + "1"
            num = num - bin
         else
            numbin = numbin + "0"
         ok
     next

     see numbin

     see nl


func convBinToDec(num)

     see "" + num + " => "

     numstr = string(num)
     dot = substr(numstr,".")
     num1 = substr(numstr,1,dot-1)
     num2 = substr(numstr,dot+1,len(numstr)-dot)

     numdec = 0
     for n = 1 to len(num1)
         if num1[n] = "1"
            numdec = numdec + pow(2,len(num1)-n)
         ok
     next

     numdig = 0
     for n = 1 to len(num2)
         if num2[n] = "1"
            numdig = numdig + 1/pow(2,n)
         ok
     next
     numdig = string(numdig)
     numdig = substr(numdig,"0.","")

     see "" + numdec + "." + numdig
