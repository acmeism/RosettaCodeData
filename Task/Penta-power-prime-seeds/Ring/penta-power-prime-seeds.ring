load "stdlibcore.ring"
see "working..." + nl

num = 1
sum = 0
while true
      n0 = pow(num,0)+num+1
      n1 = pow(num,1)+num+1
      n2 = pow(num,2)+num+1
      n3 = pow(num,3)+num+1
      n4 = pow(num,4)+num+1
      if isPrime(n0) = 1 and isPrime(n1) = 1 and isPrime(n2) = 1 and
         isPrime(n3) = 1 and isPrime(n4) = 1
         see "" + num + "  "
         sum +=1
         if sum%5 = 0
            see nl
         ok
         if sum = 30
            exit
         ok
      ok
      num += 2
end
"done..." + nl
