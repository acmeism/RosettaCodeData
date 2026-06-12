load "stdlib.ring"

see "working..." + nl
decimals(0)
row = 0
num = 0
nr = 0
numsum25 = 0
limit1 = 25
limit2 = 5000

for n = 1 to limit2
    if isprime(n)
       bool = sum25(n)
       if bool = 1
          row = row + 1
          see "" + n + " "
          if (row%5) = 0
              see nl
          ok
       ok
    ok
next

see nl + "Found " + row + " sum25 primes below 5000" + nl

time1 = clock()
see nl
row = 0

while true
      num = num + 1
      str = string(num)
      for m = 1 to len(str)
          if str[m] = 0
             loop
          ok
      next
      if isprime(num)
         bool = sum25(num)
         if bool = 1
            nr = num
            numsum25 = numsum25 + 1
          ok
      ok
      time2 = clock()
      time3 = (time2-time1)/1000/60
      if time3 > 30
         exit
      ok
end

see "There are " + numsum25 + " sum25 primes that contain no zeroes (during 30 mins)" + nl
see "The last sum25 prime found during 30 mins is: " + nr + nl
see "time = " + time3 + " mins" + nl
see "done..." + nl

func sum25(n)
     sum = 0
     str = string(n)
     for n = 1 to len(str)
         sum = sum + number(str[n])
     next
     if sum = limit1
        return 1
     ok
